import pandas as pd
import logging
from sqlalchemy import create_engine
from sqlalchemy.orm import Session
import os
from fastapi import FastAPI
from typing import List
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
origins = ["*"]
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)


class Score(BaseModel):
    contest_id: int
    judge_id: int
    rider_id: int
    run_num: int
    contest_round: str
    point_type: str
    point_value: float



class ScoreCard(BaseModel):
    scores: List[Score]

judge_list = [
    {"judge_id": "1", "judge_name": "Lukasz Ciszak"},
    {"judge_id": "2", "judge_name": "Tony Gale"},
    {"judge_id": "3", "judge_name": "Patrick Thies"},
    {"judge_id": "4", "judge_name": "Patrick Lozano"},
    {"judge_id": "5", "judge_name": "Monica Tusinean"},
    {"judge_id": "6", "judge_name": "Simon Kux"}
]

rider_list = [
    {"rider_id": "1", "division": "Amateurs", "rider_name": "Matej Kouba"},
    {"rider_id": "2", "division": "Masters", "rider_name": "Guenter Mokulys"},
    {"rider_id": "3", "division": "Girls", "rider_name": "Jakub Janczewski"},
    {"rider_id": "4", "division": "Pro", "rider_name": "Marius Constantin"},
    {"rider_id": "5", "division": "Rookies", "rider_name": "Nenad Kocic"},
    {"rider_id": "6", "division": "Sponsored Amateurs", "rider_name": "Hayato Kojima"}
]

# get environment variables
DB_URL = os.getenv("DB_URL")
if DB_URL is None:
    logging.warning("DB_URL not provided. Using default.")
    DB_URL = "localhost:5432"
logging.info("DB_URL="+DB_URL)

DB_USER = os.getenv("DB_USER")
if DB_USER is None:
    logging.warning("DB_USER not provided. Using default.")
    DB_USER = "fsrest"
logging.info("DB_USER="+DB_USER)

DB_PASSWORD = os.getenv("DB_PASSWORD")
if DB_PASSWORD is None:
    logging.warning("DB_PASSWORD not provided. Using default.")
    DB_PASSWORD = "fsrest"
logging.info("DB_PASSWORD="+DB_PASSWORD)

DB_NAME = os.getenv("DB_NAME")
if DB_NAME is None:
    logging.warning("DB_NAME not provided. Using default.")
    DB_NAME = "fsrest"
logging.info("DB_NAME="+DB_NAME)

# create engine
engine = create_engine('postgresql+psycopg2://'+DB_USER+':'+DB_PASSWORD+'@'+DB_URL+'/'+DB_NAME)

@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/get_judge")
def get_judge_list(contest_id: int):
    res = judge_list
    try:
        judge_list_df = pd.read_sql_table(
            'select j.judge_id, j.judge_name from judge j inner join contest_judge cj on j.judge_id = cj.judge_id where cj.contest_id='+str(int(contest_id)),
            con=engine
        )
        res=judge_list_df.to_dict('records')
    except:
        logging.error("Problem fetching data")
    return res


@app.get("/get_rider")
def get_rider_list(contest_id: int):
    res = rider_list
    try:
        rider_list_df = pd.read_sql(
            "select r.rider_id ,r.rider_name ,cr.division from rider r inner join contest_rider cr ON r.rider_id=cr.rider_id where cr.contest_id="+str(int(contest_id)),
            con=engine
        )
        res = rider_list_df.to_dict('records')
    except:
        logging.error("Problem fetching data")
    return res


@app.get("/get_scorecard")
def get_scorecard(contest_id=None, rider_id=None, judge_id=None, run=None, contest_round=None):
    return Score()


@app.post("/set_score")
def set_score(score_card: ScoreCard):
    result = {
        "status": "OK",
        "message": ""
    }
    error_result = {
        "status": "ERROR",
        "message": ""
    }

    try:
        scores = score_card.scores
        df_run_points = pd.DataFrame([o.__dict__ for o in scores])

        # split into run and run points
        df_run = df_run_points[['contest_id', 'judge_id', 'rider_id', 'run_num', 'contest_round']].drop_duplicates().copy().head(1)


        #------------------------------------------------------------
        # there is an assumption that this is for just one run record!
        #------------------------------------------------------------
        query="select count(*) as cnt from run_score rs where rs.rider_id="+str(int(df_run.rider_id[0]))+\
              " and rs.contest_id="+str(int(df_run.contest_id[0]))+\
              " and rs.judge_id="+str(int(df_run.judge_id[0]))+\
              " and rs.run_num="+str(int(df_run.run_num[0]))+\
              " and contest_round='"+df_run.contest_round[0]+"'"

        db_run = pd.read_sql(
            query,
            con=engine
        )

        num_rec = db_run.cnt[0]
        if num_rec > 0:
            error_result["message"] = "This runs has already been scored"
            logging.error("This runs has already been scored")
            return error_result

        #start the transaction
        session = Session(engine)
        try:
            #-- insert run
            res=df_run.to_sql('run_score', engine,if_exists='append',index=False)
            logging.info(res)
            #-- insert scores
            res=df_run_points.to_sql('run_score_point',engine,if_exists='append',index=False)
            logging.info(res)
            session.commit()
        except Exception as e:
            error_result["message"] = str(e)
            logging.error(str(e))
            session.rollback()
            return error_result
        finally:
            session.close()


    except Exception as e:
        error_result["message"]=str(e)
        logging.error(str(e))
        return error_result

    return result
