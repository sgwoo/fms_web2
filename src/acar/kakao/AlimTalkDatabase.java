package acar.kakao;



import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import acar.util.AddUtil;

import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

/*
import java.util.ArrayList;
import java.util.*;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;
*/

public class AlimTalkDatabase
{
	private static AlimTalkDatabase instance;
	private DBConnectionManager connMgr;   
	
	private static final String KEY = "d370da99bbf9866897f99b463fa619ca9001ce20";  //아마존카_알림 

	private final String DATA_SOURCE	= "acar";
	private final String DATA_SOURCE1	= "biztalk";   //acar에서 biztalk으로 변경예정 
 
	public static synchronized AlimTalkDatabase getInstance() {
		if (instance == null)
			instance = new AlimTalkDatabase();
		return instance;
	}
    
   	private AlimTalkDatabase()  {
		connMgr =DBConnectionManager.getInstance();
	}
   	
   	
    // 알림톡 전송 헬퍼 (템플릿 조합)
    public boolean sendMessage(String tplCode, List<String> fields, String recipientNum, String callbackNum)  throws DatabaseException, DataSourceEmptyException{
     		
    //    AlimTemplateDatabase at_db = AlimTemplateDatabase.getInstance();

        AlimTemplateBean templateBean = selectTemplate(tplCode);
        String content = templateBean.getContent();

        for (String field : fields) {
            content = content.replaceFirst("\\#\\{.*?\\}", field);
        }

        return sendMessage(1008, tplCode, content, recipientNum, callbackNum, null);
    }

	
    
    
    // 알림톡 예약 전송 헬퍼 (템플릿 조합)
    public boolean sendMessageReserve(String tplCode, List<String> fields, String recipientNum, String callbackNum, String reserveDate)  throws DatabaseException, DataSourceEmptyException {
   //     AlimTemplateDatabase at_db = AlimTemplateDatabase.getInstance();

        AlimTemplateBean templateBean = selectTemplate(tplCode);
        String content = templateBean.getContent();

        for (String field : fields) {
            content = content.replaceFirst("\\#\\{.*?\\}", field);
        }

        return sendMessage(1008, tplCode, content, recipientNum, callbackNum, reserveDate);
    }

    // 알림톡 웹 전송 헬퍼 (웹에서 템플릿을 완성시켜서 보냄)
    public boolean sendMessage(int msgType, String tplCode, String content, String recipientNum, String callbackNum, String reserveDate)  throws DatabaseException, DataSourceEmptyException{
        AlimTalkBean bean = new AlimTalkBean();
        bean.setMsg_type(msgType);
        bean.setTemplate_code(tplCode);
        bean.setContent(content);
        bean.setRecipient_num(recipientNum);
        bean.setCallback(callbackNum);

        // 예약일이 없으면 현재 시간
        if (reserveDate == null) {
            bean.setDate_client_req(new java.util.Date());
        }
        else {
        	
            SimpleDateFormat dt = new SimpleDateFormat("yyyyMMddhhmmss");
          
            try {
                bean.setDate_client_req(dt.parse(reserveDate) );
            } catch (ParseException e) {
                e.printStackTrace();
                // 형식이 잘못?으면 그냥 현재 시간
                bean.setDate_client_req(new java.util.Date());
            }
        }

        return insertMessage(bean);
    }

       // 알림톡 예약 전송 헬퍼 (템플릿 조합) -  etc fiiled 추가   - etc1: rent_l_cd , etc2:user_id 
    public boolean sendMessageReserve(String tplCode, List<String> fields, String recipientNum, String callbackNum, String reserveDate, String etc1, String etc2 )  throws DatabaseException, DataSourceEmptyException{
   //     AlimTemplateDatabase at_db = AlimTemplateDatabase.getInstance();

        AlimTemplateBean templateBean = selectTemplate(tplCode);
        String content = templateBean.getContent();

        for (String field : fields) {
        	content = content.replaceFirst("\\#\\{.*?\\}", field);
        }

        return sendMessage(1008, tplCode, content, recipientNum, callbackNum, reserveDate, etc1, etc2 );
    }


   // 알림톡 예약 전송 헬퍼 (템플릿 완성후 친구톡으로  - 반려된 경우 contents 작성에 사용됨 )
    public boolean sendMessage(int msgType, String tplCode, List<String> fields, String recipientNum, String callbackNum, String reserveDate, String etc1, String etc2 )  throws DatabaseException, DataSourceEmptyException{
    //    AlimTemplateDatabase at_db = AlimTemplateDatabase.getInstance();

        AlimTemplateBean templateBean = selectTemplate(tplCode);
        String content = templateBean.getContent();

        for (String field : fields) {
            content = content.replaceFirst("\\#\\{.*?\\}", field);
        }

		 if ( msgType > 1008  ) tplCode = "0";
		 
        return sendMessage(msgType, tplCode, content, recipientNum, callbackNum, reserveDate , etc1, etc2 );
    }

 
	 // 알림톡 웹 전송 헬퍼 (웹에서 템플릿을 완성시켜서 보냄)
    public boolean sendMessage(int msgType, String tplCode, String content, String recipientNum, String callbackNum, String reserveDate, String etc1, String etc2 )  throws DatabaseException, DataSourceEmptyException{
        AlimTalkBean bean = new AlimTalkBean();
        bean.setMsg_type(msgType);
        bean.setTemplate_code(tplCode);
        bean.setContent(content);
        bean.setRecipient_num(recipientNum);
	     bean.setCallback(callbackNum);
	     bean.setEtc_text_1(etc1);
	     bean.setEtc_text_2(etc2);

        // 예약일이 없으면 현재 시간
        if (reserveDate == null) {
            bean.setDate_client_req(new java.util.Date());
        }
        else {
        	
            SimpleDateFormat dt = new SimpleDateFormat("yyyyMMddhhmmss");
          
            try {
                bean.setDate_client_req(dt.parse(reserveDate) );
            } catch (ParseException e) {
                e.printStackTrace();
                // 형식이 잘못?으면 그냥 현재 시간
                bean.setDate_client_req(new java.util.Date());
            }
        }

        return insertMessage(bean);
    }

    // 알림톡 한 건 등록
    public boolean insertMessage(AlimTalkBean bean)  throws DatabaseException, DataSourceEmptyException{
    	 Connection con1 = connMgr.getConnection(DATA_SOURCE1);

         if(con1 == null)
              throw new DataSourceEmptyException("Can't get Connection !!");

        boolean flag = true;
        PreparedStatement pstmt = null;
        String query = "";

        query = "INSERT INTO ATA_MMT_TRAN ( " +
                    "mt_pr, date_client_req, template_code, content, recipient_num, " +
                    "msg_status, subject, callback, sender_key, msg_type , etc_text_1, etc_text_2  " +
                ")" +
                "VALUES ( " +
                    "SQ_ATA_MMT_TRAN_01.NEXTVAL, ?, ?, ?, ?, " +
                    "?, ?, ?, ?, ?, ?, ?  " +
                ")";

        try
        {
        	con1.setAutoCommit(false);

			if(bean.getCallback().equals("")){
				bean.setCallback("02-757-0802");
			}

            pstmt = con1.prepareStatement(query);
            pstmt.setTimestamp(1, new Timestamp(bean.getDate_client_req().getTime()));        // 전송 시간
            pstmt.setString(2, bean.getTemplate_code());        // 템플릿 코드
            pstmt.setString(3, bean.getContent());              // 내용
            pstmt.setString(4, bean.getRecipient_num());        // 수신자 번호
            pstmt.setString(5, "1");                        // 메시지 상태: 1 (전송대기)
            pstmt.setString(6, " ");                        // 제목: 사용안함
            pstmt.setString(7, bean.getCallback());             // 발신자 번호
            pstmt.setString(8, KEY);                            // 발신 프로필 키
            pstmt.setInt(9, bean.getMsg_type());                // msg type
            pstmt.setString(10, bean.getEtc_text_1());                // etc1- rent_l_cd
            pstmt.setString(11, bean.getEtc_text_2());                // etc2 - user_id

            pstmt.executeUpdate();
            pstmt.close();

            con1.commit();

    	}catch(Exception se){
            try{
                flag = false;
				System.out.println("AlimTalkDatabase:insertMessage(AlimTalkBean bean)]"+se);            
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con1.setAutoCommit(true);
                if ( pstmt != null )	pstmt.close();
            }catch(SQLException _ignored){}	         
	            connMgr.freeConnection(DATA_SOURCE1, con1);
		  con1 = null;
        }
        return flag;
    }
    

    /**
     *	사용자 검색용
     *  mode - CLIENT : 고객사용자, EMP : 사원사용자, BUS_EMP : 영업담당자, MNG_EMP : 관리담당자
     */
    public Vector getUserList(String dept, String br_id, String mode, String use_yn) throws DatabaseException, DataSourceEmptyException{
   	 Connection conn = connMgr.getConnection(DATA_SOURCE);

     if(conn == null)
          throw new DataSourceEmptyException("Can't get Connection !!");

        String query =	" select  a.dept_id, a.USER_ID, a.USER_NM,    decode(a.user_pos,'대표이사', 0, '부장', 1, '팀장', 2, '이사', 3, '차장', 4, '과장', 5, '대리', 6, 9) POS, a.user_pos, \n"+
                "        a.enter_dt, nvl(b.jg_dt,a.enter_dt) jg_dt, '1' st ,  a.USER_M_TEL, a.hot_tel, a.ID , c.br_nm, c.br_addr, c.tel as br_tel, a.loan_st  \n"+
                " from  USERS a, (SELECT user_id, max(jg_dt) jg_dt FROM INSA_POS GROUP BY user_id) b, branch c \n"+
                " where  a.user_id=b.user_id(+) and a.br_id=c.br_id \n"+
                " ";

        if(!use_yn.equals(""))				query += " and a.use_yn = '"+ use_yn +"' ";
        if(!dept.equals(""))				query += " and a.DEPT_ID = '"+ dept +"' ";

        if(!br_id.equals("") && !mode.equals("PARTNER"))
            query += " and a.BR_ID = '"+ br_id +"' ";

        if(mode.equals("CLIENT"))			query += " and a.DEPT_ID is null ";
        else if(mode.equals("EMP"))			query += " and a.DEPT_ID in ('0001','0002','0003','0004','0006','0007','0008','0005','9999','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018', '0020')  \n";
        else if(mode.equals("BUS_EMP"))		query += " and a.DEPT_ID = '0001' ";
        else if(mode.equals("MNG_EMP"))		query += " and a.DEPT_ID = '0002' ";
        else if(mode.equals("GEN_EMP"))		query += " and a.DEPT_ID = '0003' ";
        else if(mode.equals("AGENT"))		query += " and a.DEPT_ID = '1000' ";
        else if(mode.equals("BUS_MNG_EMP")) query += " and a.DEPT_ID in ('0001','0002') ";
        else if(mode.equals("HEAD"))		query += " and a.USER_POS not in ('인턴사원','사원','대리','대표이사','주주','외부업체') ";
        else if(mode.equals("HEAD2"))		query += " and a.USER_ID in ('000003','000004','000005','000006','000052','000053','000026') ";
        else if(mode.equals("BODY"))		query += " and a.USER_POS in ('사원','대리','과장') ";
        else if(mode.equals("BODY2"))		query += " and a.DEPT_ID in ('0001','0002','0003','0007','0008') ";
        else if(mode.equals("BUS_ID"))		query += " and a.USER_ID in (select BUS_ID from cont group by BUS_ID) ";
        else if(mode.equals("BUS_ID2"))		query += " and a.USER_ID in (select BUS_ID2 from cont group by BUS_ID2) ";
        else if(mode.equals("MNG_ID"))		query += " and a.USER_ID in (select MNG_ID from cont group by MNG_ID) ";
        else if(mode.equals("MESSAGE"))		query += " and a.DEPT_ID in ('0001','0002','0003','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018' , '0020') and a.M_IO = 'Y' ";//메제시받기 체크된 사람만

        else if(mode.equals("MESSAGE_S"))	query += " and a.DEPT_ID in ('0001') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_B"))	query += " and a.DEPT_ID in ('0007') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_D"))	query += " and a.DEPT_ID in ('0008') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_K"))	query += " and a.DEPT_ID in ('0009') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_J"))	query += " and a.DEPT_ID in ('0010') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_G"))	query += " and a.DEPT_ID in ('0011') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_I"))	query += " and a.DEPT_ID in ('0012') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_W"))	query += " and a.DEPT_ID in ('0013') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_JR"))	query += " and a.DEPT_ID in ('0017') and a.M_IO = 'Y' ";
        else if(mode.equals("MESSAGE_SP"))	query += " and a.DEPT_ID in ('0018') and a.M_IO = 'Y' ";

        else if(mode.equals("PARTNER"))		query += " and a.user_work like '%"+ br_id +"%' and a.user_m_tel is not null ";
        else if(mode.equals("loan_st"))		query += " and a.loan_st is not null  ";

        if(mode.equals("EMP")){

            query +=" union \n"+
                    " SELECT a.dept_id, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, 9 AS pos, '' user_pos, '' enter_dt, '' jg_dt, '0' st  ,  '' USER_M_TEL, '' hot_tel, '' ID, '' BR_NM, '' BR_ADDR, '' BR_TEL, '' loan_st  \n"+
                    " FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
                    " WHERE  a.dept_id NOT IN ('8888') AND a.dept_id=B.CODE \n"+
                    " GROUP BY a.dept_id HAVING COUNT(*)>0 \n"+
                    " ";
        }


        if(use_yn.equals("N")){
            query += " ORDER BY a.user_id ";
        }else{
            if(mode.equals("PARTNER")){
                query += " ORDER BY decode(a.user_id,'000223',0,1), a.enter_dt, a.user_id";
            }else{
//				query += " ORDER BY a.dept_id, decode(a.user_pos,'사원',1,0), a.user_id ";
                query += " ORDER BY dept_id, st, pos,  jg_dt , enter_dt, user_nm ";
            }
        }

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        
        //System.out.println("[AlimtalkDatabase:getUserList]\n"+query);

        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();

            while(rs.next())
            {
                Hashtable ht = new Hashtable();
                for(int pos =1; pos <= rsmd.getColumnCount();pos++)
                {
                    String columnName = rsmd.getColumnName(pos);
                    ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
                }
                vt.add(ht);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[AlimtalkDatabase:getUserList]"+se);
			 throw new DatabaseException();
       }finally{
           try{
               if(rs != null )		rs.close();
               if(pstmt != null)	pstmt.close();          
           }catch(SQLException _ignored){}
           connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
       }
       return vt;
   }
    
  
    //계약검색용
    public Vector getContList_20160614(String s_kd, String t_wd, String andor, String gubun4, String gubun5, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException{
     	 Connection conn = connMgr.getConnection(DATA_SOURCE);
     	 
     	 if(conn == null)
             throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";

        query = " select   \n"+
                "        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, nvl(d.rent_dt,a.rent_dt) as rent_dt, nvl(c.rent_suc_dt,y.cls_dt) as rent_suc_dt,  \n"+
                "       decode(a.use_yn, 'Y', '진행', 'N', '해지', null, '미결' ) use_yn, \n"+
                "        b.firm_nm, b.client_nm, e.r_site as site_nm,      j.car_nm, f.car_no, \n"+
                "        decode(m.rent_st,'1','',decode(sign(to_date(d.rent_dt,'YYYYMMDD')-to_date(y.cls_dt,'YYYYMMDD')),1,'연장',0,'연장','')) ext_st2, \n"+
                "        decode(a.rent_st,'1','신규','2','연장','3','대차','4','증차','5','연장','6','재리스','7','재리스') rent_st,  \n"+
                "        decode(nvl(a.car_gu,a.reg_id),'1','신차','0','재리스','2','중고차','3','월렌트') car_gu,  \n"+
                "        decode(d.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way, \n"+
                "        nvl(decode(d.rent_st, '1', a.bus_id, d.ext_agnt),a.bus_id) bus_id, "+
                "        k.user_nm as bus_nm, k.user_m_tel as bus_m_tel,  \n"+
                "        a.bus_id2, \n"+
                "        n.user_nm bus_nm2, n.user_m_tel as bus2_m_tel,  \n"+
                "        a.mng_id, u.user_nm as mng_nm, u.user_m_tel as mng_m_tel,  \n"+
                "        z.ins_com_id , m.rent_start_dt , m.rent_end_dt , decode(a.car_st , '4', '(월)', ' ') st_nm \n"+   //대여개시일 , 만료일 추가 
                " from \n"+
                "		 cont a, client b, cont_etc c, fee d, client_site e, car_reg f, \n"+
                "		 car_etc h, car_nm i, car_mng j, users k, "+
                "	     users n, "+
                "	     users u, \n"+
                "		 ( select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(nvl(rent_start_dt,'')) rent_start_dt, max(nvl(rent_end_dt,'')) rent_end_dt \n"+
                "		   from   fee  \n"+
                "          group by rent_mng_id, rent_l_cd \n"+
                "        ) m, \n"+
                "        ( select rent_mng_id, reg_dt, cls_dt, cls_st from cls_cont where cls_st in ('4','5')) y, \n"+
                "        ( select a.car_mng_id, a.ins_com_id    \n"+
                "          from   insur a, ins_cls b   \n"+
                "          where  a.car_mng_id = b.car_mng_id(+) and a.ins_st = b.ins_st(+)   \n"+
                "                 AND a.ins_start_dt <= TO_CHAR(sysdate-1,'YYYYMMDD')  \n"+
                "                 AND ( (b.car_mng_id IS NULL and a.ins_exp_dt > TO_CHAR(sysdate,'YYYYMMDD'))  OR   (b.car_mng_id IS NOT NULL AND b.exp_dt >  TO_CHAR(sysdate,'YYYYMMDD')) )  \n"+
                "        ) z, \n"+
                "        fee_etc mm,  \n"+
                "        (select a.car_mng_id from cont a, commi c \n"+
                "    where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2' and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL group by a.car_mng_id) ac \n"+
                " where  \n"+
                "        a.client_id=b.client_id \n"+
                "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
                "        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
                "        and a.client_id=e.client_id(+) and a.r_site=e.seq(+) \n"+
                "        and a.car_mng_id=f.car_mng_id(+) \n"+
                "        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
                "        and h.car_id=i.car_id and h.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code \n"+
                "        AND ((d.RENT_ST='1' AND a.BUS_ID = k.user_id)  OR (d.RENT_ST<>'1' and d.ext_agnt is not null AND d.ext_agnt = k.user_id)  OR (d.RENT_ST<>'1' and d.ext_agnt is null AND a.bus_id = k.user_id )) \n"+
                "        and a.bus_id2=n.user_id \n"+
                "        and d.rent_mng_id=m.rent_mng_id and d.rent_l_cd=m.rent_l_cd and d.rent_st=m.rent_st \n"+
                "        and a.mng_id=u.user_id(+) \n"+
                "        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) \n"+
                "        and a.car_mng_id=z.car_mng_id(+) \n"+
                "        and d.rent_mng_id=mm.rent_mng_id and d.rent_l_cd=mm.rent_l_cd and d.rent_st=mm.rent_st \n"+
                "        and a.car_mng_id=ac.car_mng_id(+) \n"+
                " ";

        String search = "";
        String what = "";

        String dt1 = "";
        String dt2 = "";

        //계약(연장)일자
        if(gubun4.equals("1")){

            //당월
            if(gubun5.equals("4"))			query += " and ( (d.rent_st='1' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%') or (d.rent_st<>'1' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%') ) ";
                //전월
            else if(gubun5.equals("5"))		query += " and ( (d.rent_st='1' and a.rent_dt like to_char(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%') or (d.rent_st<>'1' and a.rent_dt like to_char(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%') ) ";
                //당일
            else if(gubun5.equals("1"))		query += " and ( (d.rent_st='1' and a.rent_dt=to_char(sysdate,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt=to_char(sysdate,'YYYYMMDD')) ) ";
                //전일
            else if(gubun5.equals("2"))		query += " and ( (d.rent_st='1' and a.rent_dt=to_char(sysdate-1,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt=to_char(sysdate-1,'YYYYMMDD')) ) ";
                //2일
            else if(gubun5.equals("3"))		query += " and ( (d.rent_st='1' and a.rent_dt between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')) ) ";
                //기간
            else if(gubun5.equals("6")){
                if(!st_dt.equals("") && !end_dt.equals("")) query += " and ( (d.rent_st='1' and a.rent_dt between '"+st_dt+"' and '"+end_dt+"') or (d.rent_st<>'1' and d.rent_dt between '"+st_dt+"' and '"+end_dt+"') ) ";
            }

            //승계일자
        }else if(gubun4.equals("2")){

            dt1 = "substr(c.rent_suc_dt,1,6)";
            dt2 = "c.rent_suc_dt";

            if(gubun5.equals("4"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";				//당월
            else if(gubun5.equals("5"))		query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%'";	//전월
            else if(gubun5.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";				//당일
            else if(gubun5.equals("2"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";			//전일
            else if(gubun5.equals("3"))		query += " and "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') ";//2일
            else if(gubun5.equals("6")){
                if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between '"+st_dt+"' and '"+end_dt+"'";
            }

        }

        if(s_kd.equals("1"))	what = "upper(b.firm_nm||e.r_site)";
        if(s_kd.equals("2"))	what = "a.rent_l_cd";
        if(s_kd.equals("3"))	what = "f.car_no||' '||f.first_car_no";
        if(s_kd.equals("8"))	what = "k.user_nm";
        if(s_kd.equals("10"))	what = "n.user_nm";
        if(s_kd.equals("11"))	what = "u.user_nm";
        if(s_kd.equals("13"))	what = "upper(nvl(b.client_nm||e.site_jang, ' '))";
        if(s_kd.equals("19"))	what = "b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' )||TEXT_DECRYPT(e.enp_no, 'pw' ) ";

        if(!what.equals("") && !t_wd.equals("")){
            //		if(!s_kd.equals("1") && !s_kd.equals("2") && !s_kd.equals("3") && !gubun1.equals("R") && !gubun1.equals("C"))		query += " and a.car_st<>'2'";				//차량번호 검색이 아닌경우 보유차는 뺄것
            if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");
            if(s_kd.equals("14")||s_kd.equals("17")||s_kd.equals("18"))	t_wd = AddUtil.replace(t_wd,"-","");

            if(s_kd.equals("1")||s_kd.equals("2")||s_kd.equals("13")||s_kd.equals("16")){
                query += " and "+what+" like upper('%"+t_wd+"%') \n";
            }else{
                query += " and "+what+" like '%"+t_wd+"%' \n";
            }

            if(s_kd.equals("17"))		query += " order by a.use_yn desc, f.init_reg_dt desc, f.car_doc_no desc  \n";
            else  						query += " order by a.use_yn desc, a.rent_dt desc, a.rent_mng_id desc, a.reg_dt desc, a.update_dt desc \n";
        }else{

            if(s_kd.equals("10")){ //영업담당자
                query += " and a.bus_id2 is null order by a.rent_dt, a.rent_start_dt \n";
            }else{
                //계약관리 디폴트
						/*승계미포함*/query += " and (a.use_yn is null or a.use_yn='Y') and b.client_id<>'000228' and a.car_st in ('1','3','5', '4') \n"; //계약관리 디폴트에서 보유차와 월렌트는 제외

                //미결,신차,재리스,연장,승계순
                query += " order by decode(y.cls_st,'5',decode(sign(to_date(d.rent_start_dt)-to_date(y.cls_dt,'YYYYMMDD')),1,0,0,0,1),0), "+
                        "          decode(y.cls_st||decode(m.rent_st,'1','',decode(sign(to_date(d.rent_dt,'YYYYMMDD')-to_date(y.cls_dt,'YYYYMMDD')),1,'연장',0,'연장','')),'5', nvl(c.rent_suc_dt,y.cls_dt), nvl(d.rent_dt,a.rent_dt)) desc, "+
                        "          a.use_yn desc, decode(d.rent_st,'1',1,2), decode(nvl(a.car_gu,a.reg_id),'0','1','2','2','1','3') desc, a.rent_st desc \n";
            }

        }


        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();

            while(rs.next())
            {
                Hashtable ht = new Hashtable();
                for(int pos =1; pos <= rsmd.getColumnCount();pos++)
                {
                    String columnName = rsmd.getColumnName(pos);
                    ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
                }
                vt.add(ht);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[AlimtalkDatabase:getContList_20160614]"+se);
			 throw new DatabaseException();
        }finally{
          try{
              if(rs != null )		rs.close();
              if(pstmt != null)	pstmt.close();          
          }catch(SQLException _ignored){}
          connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
        }
        return vt;
	 }    
            
    
    //영업사원 검색용 
	 /**
     * 영업소 사원 전체 조회.
     */
    public Vector  getCarOffEmpAllList2(String gubun1, String gubun2, String gubun3, String gubun, String gu_nm, String sort_gubun, String sort, String cng_rsn, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException{
    	 Connection conn = connMgr.getConnection(DATA_SOURCE);
     	 
    	 if(conn == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	 
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        Vector vt = new Vector();
	

		if(gubun1.equals("") && gubun2.equals("") && gubun3.equals("") && gu_nm.equals("") && st_dt.equals("") && end_dt.equals("")) subQuery = " and nvl(a.reg_dt, a.upd_dt)=to_char(sysdate,'yyyymmdd') ";
		
		if(!gu_nm.equals("")){
			if(gubun.equals("car_comp")){				subQuery = "and c.nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off")){			subQuery = "and b.car_off_nm like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_nm")){			subQuery = "and nvl(a.emp_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_email")){		subQuery = "and nvl(a.emp_email,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("emp_m_tel")){		subQuery = "and nvl(a.emp_m_tel,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("car_off_nm")){		subQuery = "and nvl(b.car_off_nm,' ') like '%" + gu_nm + "%'\n";
			}else if(gubun.equals("damdang_id")){		subQuery = "and d.damdang_id ='"+ gu_nm + "' \n";
			}
		}

		if(!gubun1.equals(""))	subQuery += " and b.car_off_addr like '%" + gubun1.trim() + "%'";

		if(!gubun2.equals(""))	subQuery += " and b.car_off_addr like '%" + gubun2.trim() + "%'";
        
		if(!gubun3.equals(""))	subQuery += " and b.car_comp_id = '" + gubun3 + "'";
	
		//담당자지정사유, 지정(변경)일
		if(st_dt.equals(""))	st_dt ="00000000";
		if(end_dt.equals(""))	end_dt="99999999";
		if(!cng_rsn.equals("")){
			subQuery += " and d.cng_rsn ='"+ cng_rsn + "' \n";			
		}
		if((!st_dt.equals(""))&&(!end_dt.equals(""))){
			subQuery += " and d.cng_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		}

		String query = "";
        query = "select a.emp_id as EMP_ID,\n"
						+ "a.car_off_id as CAR_OFF_ID,\n" 
						+ "b.car_off_nm as CAR_OFF_NM, b.car_off_st, b.owner_nm as OWNER_NM,\n"
						+ "b.car_comp_id as CAR_COMP_ID,\n"
						+ "c.nm as CAR_COMP_NM,\n"
						+ "a.cust_st as CUST_ST,\n"
						+ "a.emp_nm as EMP_NM,\n"
						+ "a.emp_ssn as EMP_SSN,\n"
						+ "b.car_off_tel as CAR_OFF_TEL,\n"
						+ "b.car_off_fax as CAR_OFF_FAX,\n"
						+ "a.emp_m_tel as EMP_M_TEL,\n"
						+ "a.emp_pos as EMP_POS,\n"			
						+ "a.emp_acc_nm as EMP_ACC_NM,a.emp_post as EMP_POST,a.emp_addr as EMP_ADDR, a.etc as ETC,\n"
						+ "b.car_off_post as CAR_OFF_POST, b.car_off_addr as CAR_OFF_ADDR, \n"
						+ "nvl(a.reg_dt,'-') reg_dt, a.reg_id, a.upd_dt, a.upd_id, \n"
						+ "a.emp_h_tel, a.emp_sex, a.use_yn, a.sms_denial_rsn, \n"
						+ "d.seq, d.damdang_id, d.cng_rsn, d.cng_dt , "
						+ "b.one_self_yn, a.agent_id, a.emp_dept, a.fraud_care \n"
				+ "from car_off_emp a, car_off b, code c, "
				+ "		(select emp_id, seq, damdang_id, cng_rsn, cng_dt from car_off_edh a where a.seq=(select max(seq) from car_off_edh b where a.emp_id=b.emp_id)) d "
				+ "where a.car_off_id = b.car_off_id \n"
				+ "and b.car_comp_id = c.code\n"
				+ "and c.c_st = '0001'\n"
				+ "and a.emp_id = d.emp_id(+) "
				+ subQuery;
		
		if(!sort_gubun.equals("") && sort_gubun.equals("damdang_id")){	 
			query += " order by "+sort_gubun+" "+sort;
		}else{
			query += " order by nvl(a.upd_dt,a.reg_dt) desc";
			if(!sort_gubun.equals(""))	query += ", "+sort_gubun+" "+sort;
		}

	  
       try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();

            while(rs.next())
            {
                Hashtable ht = new Hashtable();
                for(int pos =1; pos <= rsmd.getColumnCount();pos++)
                {
                    String columnName = rsmd.getColumnName(pos);
                    ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
                }
                vt.add(ht);
            }
      }catch(SQLException se){
			 System.out.println("[AlimtalkDatabase:getCarOffEmpAllList2]"+se);
			 throw new DatabaseException();
      }finally{
        try{
            if(rs != null )		rs.close();
            if(pstmt != null)	pstmt.close();          
        }catch(SQLException _ignored){}
        connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
      }
      return vt;
	 }    
     
    /**
     * 계약 추가 정보 조회
     * jjlim@20171116
     */
    public Hashtable getContractMoreInfo(String rentMngId, String rentLCd) throws DatabaseException, DataSourceEmptyException{
   	 	Connection conn = connMgr.getConnection(DATA_SOURCE);
 	 
   	 	if(conn == null)
           throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        Hashtable ht = new Hashtable();

        String query = "";
        query = "select cr.CAR_MNG_ID, " +
                    "cr.CAR_NM, " +
                    "cr.CAR_NO, " +
                    "cr.CAR_NUM, " +
                    "c.RENT_DT, " +
                    "c.RENT_START_DT, " +
                    "c.RENT_END_DT " +
                "from cont c, car_reg cr " +
                "where c.CAR_MNG_ID = cr.CAR_MNG_ID(+) " +
                    "and c.RENT_MNG_ID = ? " +
                    "and c.RENT_L_CD = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, rentMngId);
            pstmt.setString(2, rentLCd);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();

            if (rs.next())
            {
                for (int pos =1; pos <= rsmd.getColumnCount(); pos++)
                {
                    String columnName = rsmd.getColumnName(pos);
                    ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
                }
            }
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			 throw new DatabaseException();
       }finally{
           try{
        	   if(rs != null) rs.close();
               if(pstmt != null) pstmt.close();
           }catch(SQLException _ignored){}
           connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
       }
       return ht;
   }
     

	  // 템플릿 한건 가져옴
    public AlimTemplateBean selectTemplate(String tplCode) throws DatabaseException, DataSourceEmptyException{
   	 	Connection conn = connMgr.getConnection(DATA_SOURCE);
 	 
   	 	if(conn == null)
           throw new DataSourceEmptyException("Can't get Connection !!");

		AlimTemplateBean templateBean = new AlimTemplateBean();
		   
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String query =
                "SELECT NO, CODE, NAME, CONTENT, ORG_NAME, ORG_UUID, DESCRIPTION " +
                        "FROM ATA_TEMPLATE WHERE CODE = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, tplCode);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                templateBean.setNo(rs.getInt("NO"));
                templateBean.setCode(rs.getString("CODE"));
                templateBean.setName(rs.getString("NAME"));
                templateBean.setContent(rs.getString("CONTENT"));
                templateBean.setOrg_name(rs.getString("ORG_NAME"));

                templateBean.setOrg_uuid(rs.getString("ORG_UUID"));
                templateBean.setDesc(rs.getString("DESCRIPTION"));
            }
             rs.close();
			 pstmt.close();  
            
    
		  }catch(SQLException se){
				 throw new DatabaseException();
		  }finally{
		      try{
		    	   if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
		      }catch(SQLException _ignored){}
		      connMgr.freeConnection(DATA_SOURCE, conn);
			  conn = null;
		  }
		  return templateBean;
	   }
        

}
