package acar.kakao;

import acar.database.DBConnectionManager;
import acar.util.AddUtil;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

public class AlimTalkLogDatabase {

   // private static final String KEY = "eb2f4f7fb7d88ab0b689ba0dfab246d419051980";
    private static final String KEY = "d370da99bbf9866897f99b463fa619ca9001ce20";  //아마존카_알림 
 
    private Connection conn = null;
    public static AlimTalkLogDatabase db;

    public static AlimTalkLogDatabase getInstance()
    {
        if(AlimTalkLogDatabase.db == null)
            AlimTalkLogDatabase.db = new AlimTalkLogDatabase();
        return AlimTalkLogDatabase.db;
    }


    private DBConnectionManager connMgr = null;

    private void getConnection()
    {
        try
        {
            if(connMgr == null)
                connMgr = DBConnectionManager.getInstance();
            if(conn == null)
                conn = connMgr.getConnection("biztalk");   //biztalk 변경에정
        }catch(Exception e){
            System.out.println(" i can't get a connection........");
        }
    }

    private void closeConnection()
    {
        if ( conn != null )
        {
            connMgr.freeConnection("biztalk", conn);  //biztalk 변경에정
        }
    }

    // 6개월치 테이블 리스트 가져옴 (존재 여부 확인 필요)
    private List<String> getLogTableName() {
        ArrayList<String> tables = new ArrayList<String>();
        ArrayList<String> logTables = new ArrayList<String>();

        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String query =
                "SELECT TABLE_NAME FROM ALL_TABLES WHERE TABLE_NAME LIKE 'ATA_MMT_LOG_2%'";

        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                tables.add(rs.getString("TABLE_NAME"));
            }
            rs.close();
            pstmt.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null )
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
            }
            catch(Exception ignore){ }
            closeConnection();
        }

        try {
            Calendar cal = Calendar.getInstance();
            cal.add(cal.MONTH, -2);
            String beforeDateStr = new SimpleDateFormat("yyyyMM").format(cal.getTime());
            Date beforeDate = new SimpleDateFormat("yyyyMM").parse(beforeDateStr);

            for (int i = 0; i < tables.size(); i++) {
                String tableName = tables.get(i);
                String[] token = tableName.split("_");
                String logDateStr = token[token.length - 1];

                Date logDate = new SimpleDateFormat("yyyyMM").parse(logDateStr);

                if (beforeDate.getTime() <= logDate.getTime()) {
                    logTables.add(tableName);
                }

            }
        }
        catch (ParseException e) {
            e.printStackTrace();
        }

        return logTables;
    }

    // 6개월치 테이블 리스트 가져옴 (존재 여부 확인 필요)
    private List<String> getLogTableNameEm() {
        ArrayList<String> tables = new ArrayList<String>();
        ArrayList<String> logTables = new ArrayList<String>();

        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String query =
                "SELECT TABLE_NAME FROM ALL_TABLES WHERE SUBSTR(TABLE_NAME,1,12) IN ('EM_MMT_LOG_2','EM_SMT_LOG_2')";

        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                tables.add(rs.getString("TABLE_NAME"));
            }
            rs.close();
            pstmt.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null )
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
            }
            catch(Exception ignore){ }
            closeConnection();
        }

        try {
            Calendar cal = Calendar.getInstance();
            cal.add(cal.MONTH, -2);
            String beforeDateStr = new SimpleDateFormat("yyyyMM").format(cal.getTime());
            Date beforeDate = new SimpleDateFormat("yyyyMM").parse(beforeDateStr);

            for (int i = 0; i < tables.size(); i++) {
                String tableName = tables.get(i);
                String[] token = tableName.split("_");
                String logDateStr = token[token.length - 1];

                Date logDate = new SimpleDateFormat("yyyyMM").parse(logDateStr);

                if (beforeDate.getTime() <= logDate.getTime()) {
                    logTables.add(tableName);
                }

            }
        }
        catch (ParseException e) {
            e.printStackTrace();
        }

        return logTables;
    }

    // 로그 가져오기 (수신 번호로 검색)
    public List<AlimTalkLogBean> select(String[] recipients) {
        ArrayList<AlimTalkLogBean> alimTalkLogs = new ArrayList<AlimTalkLogBean>();

        // 1. 현재달 기준으로 6개월치 테이블 이름
        List<String> tables = getLogTableName();


        // 테이블이 없으면
        if (tables.size() == 0) {
            return alimTalkLogs;
        }

        String where = "";
        if (recipients.length > 0) {
            where = "WHERE RECIPIENT_NUM IN ('" + recipients[0] + "' ";
            for (int i = 1; i < recipients.length; i++) {
                where += ", '" + recipients[i] + "'";
            }
            where += ") ";

        }

        String query =
                "SELECT * FROM ( ";
        query +=
                "SELECT * FROM " + tables.get(0) + " " + where + " ";
        for (int i = 1; i < tables.size(); i++) {
            query +=
                "UNION " + "SELECT * FROM " + tables.get(i) + " " + where + " ";
        }
        query +=
                ") ORDER BY DATE_CLIENT_REQ DESC";

        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTalkLogBean alimTalkLog = new AlimTalkLogBean();
                alimTalkLog.setTemplate_code(rs.getString("TEMPLATE_CODE"));
                alimTalkLog.setDate_client_req(rs.getTimestamp("DATE_CLIENT_REQ"));
                alimTalkLog.setContent(rs.getString("CONTENT"));
                alimTalkLog.setCallback(rs.getString("CALLBACK"));
                alimTalkLog.setRecipient_num(rs.getString("RECIPIENT_NUM"));

                alimTalkLogs.add(alimTalkLog);
            }
            rs.close();
            pstmt.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null )
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
            }
            catch(Exception ignore){ }
            closeConnection();

            return alimTalkLogs;
        }
    }

    // 로그 가져오기 (계약번호로 검색)
    public List<AlimTalkLogBean> selectByContract(String rentLCd) {
        ArrayList<AlimTalkLogBean> alimTalkLogs = new ArrayList<AlimTalkLogBean>();

        // 1. 현재달 기준으로 6개월치 테이블 이름
        List<String> tables = getLogTableName();


        // 테이블이 없으면
        if (tables.size() == 0) {
            return alimTalkLogs;
        }

        String where = "WHERE A.ETC_TEXT_2 = U.USER_ID(+) ";
        if (rentLCd.equals("") == false) {
            where += "AND A.ETC_TEXT_1 = '" + rentLCd + "' ";
        }

        String query =
                "SELECT * FROM ( ";
        query +=
                "SELECT A.*, U.USER_NM FROM " + tables.get(0) + " A, amazoncar.USERS U " + where + " ";
        for (int i = 1; i < tables.size(); i++) {
            query +=
                    "UNION " + "SELECT A.*, U.USER_NM FROM " + tables.get(i) + " A, amazoncar.USERS U  " + where + " ";
        }
        query +=
                ") ORDER BY DATE_CLIENT_REQ DESC";
        
        //System.out.println("[AlimTalkLogDatabase:selectByContract()]"+ query);

        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTalkLogBean alimTalkLog = new AlimTalkLogBean();
                alimTalkLog.setTemplate_code(rs.getString("TEMPLATE_CODE"));
                alimTalkLog.setDate_client_req(rs.getTimestamp("DATE_CLIENT_REQ"));
                alimTalkLog.setContent(rs.getString("CONTENT"));
                alimTalkLog.setCallback(rs.getString("CALLBACK"));
                alimTalkLog.setRecipient_num(rs.getString("RECIPIENT_NUM"));
                alimTalkLog.setReport_code(rs.getString("REPORT_CODE"));
                alimTalkLog.setUserNm(rs.getString("USER_NM"));

                alimTalkLogs.add(alimTalkLog);
            }
            rs.close();
            pstmt.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null )
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
            }
            catch(Exception ignore){ }
            closeConnection();

            return alimTalkLogs;
        }
    }
    
    // 로그 가져오기 (담당자, 파트너로 검색)
    public List<AlimTalkLogBean> selectByBond(String type, String rent_l_cd, String bus_id, String partner_id) {
    	ArrayList<AlimTalkLogBean> alimTalkLogs = new ArrayList<AlimTalkLogBean>();

        // 1. 현재달 기준으로 6개월치 테이블 이름
        List<String> tables = getLogTableName();

        // 테이블이 없으면
        if (tables.size() == 0) {
            return alimTalkLogs;
        }

        String where = "WHERE A.ETC_TEXT_2 = U.USER_ID(+) ";
        
        if (type.equals("1")) {
        	where += "AND A.etc_text_1 = C.rent_l_cd(+) ";
        	where += "AND A.etc_text_1 = '"+rent_l_cd+"' ";
        	where += "AND A.REPORT_CODE = '1000' ";
        } else if (type.equals("2")) {
        	where += "AND A.etc_text_1 = C.rent_l_cd(+) ";
        	where += "AND (A.etc_text_2 = '"+bus_id+"' OR A.etc_text_2 = '"+partner_id+"') ";
        	where += "AND A.REPORT_CODE = '1000' ";
        }

        String query =
                "SELECT a.* , Nvl(b.firm_nm, '-') firm_nm , Nvl(c.user_nm, '-') user_nm2 FROM ( ";
        query +=
                "SELECT A.*, U.USER_NM, C.client_id FROM " + tables.get(0) + " A, amazoncar.USERS U, amazoncar.CONT C " + where + " ";
        for (int i = 1; i < tables.size(); i++) {
            query +=
                    "UNION " + "SELECT A.*, U.USER_NM, C.client_id FROM " + tables.get(i) + " A, amazoncar.USERS U, amazoncar.CONT C  " + where + " ";
        }
        query +=
                ") a, amazoncar.client b, amazoncar.users c WHERE  a.client_id = b.client_id(+) AND a.RECIPIENT_NUM = c.user_m_tel(+) ORDER BY DATE_CLIENT_REQ DESC ";
        
        //System.out.println("[AlimTalkLogDatabase:selectByBond()]"+ query);

        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTalkLogBean alimTalkLog = new AlimTalkLogBean();
                alimTalkLog.setTemplate_code(rs.getString("TEMPLATE_CODE"));
                alimTalkLog.setDate_client_req(rs.getTimestamp("DATE_CLIENT_REQ"));
                alimTalkLog.setContent(rs.getString("CONTENT"));
                alimTalkLog.setCallback(rs.getString("CALLBACK"));
                alimTalkLog.setRecipient_num(rs.getString("RECIPIENT_NUM"));
                alimTalkLog.setReport_code(rs.getString("REPORT_CODE"));
                alimTalkLog.setUserNm(rs.getString("USER_NM"));
                alimTalkLog.setUserNm2(rs.getString("USER_NM2"));
                alimTalkLog.setFirmNm(rs.getString("FIRM_NM"));

                alimTalkLogs.add(alimTalkLog);
            }
            rs.close();
            pstmt.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs != null )
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
            }
            catch(Exception ignore){ }
            closeConnection();

            return alimTalkLogs;
        }
    }

  // 로그 가져오기 (필터 검색)
    public List<AlimTalkLogBean> selectByFilter(String code, String dateType, String startDate, String endDate,
                                                String searchType, String searchKeyword) {
        ArrayList<AlimTalkLogBean> alimTalkLogs = new ArrayList<AlimTalkLogBean>();

        // 1. 현재달 기준으로 6개월치 테이블 이름
        List<String> tables = getLogTableName();

        // 테이블이 없으면
        if (tables.size() == 0) {
            return alimTalkLogs;
        }

        String where = "WHERE A.ETC_TEXT_2 = U.USER_ID(+) and  A.ETC_TEXT_1 = C. rent_l_cd(+) ";

        // 템플릿 코드
        if (code.equals("") == false) {
        	   if ( code.equals("10") ) {   //친구톡  
        	    	where += "AND A.TEMPLATE_CODE = '0' ";
        	   	} else {
            		where += "AND A.TEMPLATE_CODE = '" + code + "' ";
            	}	
        }

        // 당월
        if (dateType.equals("4")) {
            where += "AND TRUNC(A.DATE_CLIENT_REQ, 'MONTH') = TRUNC(SYSDATE, 'MONTH') ";
        }
        // 전월
        else if (dateType.equals("5")) {
            where += "AND TRUNC(A.DATE_CLIENT_REQ, 'MONTH') = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MONTH') ";
        }
        // 당일
        else if (dateType.equals("1")) {
            where += "AND TRUNC(A.DATE_CLIENT_REQ) = TO_DATE(SYSDATE) ";
        }
        // 전일
        else if (dateType.equals("2")) {
            where += "AND TRUNC(A.DATE_CLIENT_REQ) = TO_DATE(SYSDATE - 1) ";
        }
        // 2일
        else if (dateType.equals("3")) {
            where += "AND (TRUNC(A.DATE_CLIENT_REQ) = TO_DATE(SYSDATE) OR TRUNC(A.DATE_CLIENT_REQ) = TO_DATE(SYSDATE - 1)) ";
        }
        // 기간->월별
        else if (dateType.equals("6")) {
            //if (!startDate.equals("") && !endDate.equals("")) {
            //    where += "AND TRUNC(A.DATE_CLIENT_REQ) BETWEEN TO_DATE(" + startDate + ", 'YYYYMMDD') AND TO_DATE(" + endDate + ", 'YYYYMMDD') ";
            //}
//						System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ startDate);
//						System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ endDate);
        }

        if (!searchKeyword.equals("")) {
            // 계약번호
            if (searchType.equals("1")) {
                where += "AND A.ETC_TEXT_1 = '" + searchKeyword + "' ";
            }
            // 발신자
            if (searchType.equals("2")) {
                where += "AND U.USER_NM = '" + searchKeyword + "' ";
            }
            // 발신번호
            if (searchType.equals("3")) {
                where += "AND A.CALLBACK = '" + searchKeyword + "' ";
            }
            // 수신번호
            if (searchType.equals("4")) {
                where += "AND A.RECIPIENT_NUM = '" + searchKeyword + "' ";
            }
            // 문자내용
            if (searchType.equals("5")) {
                where += "AND A.CONTENT like '%" + searchKeyword + "%' ";
            }
            // 문자내용
            if (searchType.equals("6")) {
            	where += "AND A.CONTENT like '%" + searchKeyword + "%' ";
            }

        }

        String query =
                "SELECT a.* , nvl(b.firm_nm, '-') firm_nm  FROM ( ";

		if (dateType.equals("6") && AddUtil.parseInt(startDate+""+endDate) >= 201710 ) {

	        query +=
		            "SELECT A.*, U.USER_NM, c.client_id  FROM ATA_MMT_LOG_"+startDate+""+endDate+" A, amazoncar.USERS U, amazoncar.cont c  " + where + " ";

		}else{

	        query +=
		            "SELECT A.*, U.USER_NM , c.client_id  FROM " + tables.get(0) + " A, amazoncar.USERS U, amazoncar.cont c " + where + " ";
			for (int i = 1; i < tables.size(); i++) {
				query +=
	                    "UNION " + "SELECT A.*, U.USER_NM , c.client_id   FROM " + tables.get(i) + " A, amazoncar.USERS U , amazoncar.cont c  " + where + " ";
		    }
		}

        query +=
                ") a,  amazoncar.client b where a.client_id = b.client_id(+) ";

        if (!searchKeyword.equals("")) {
            // 상호
            if (searchType.equals("6")) {
                where += "AND b.firm_nm like '%" + searchKeyword + "%' ";
            }

        }
		
		query += " ORDER BY a.DATE_CLIENT_REQ DESC";


        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {

//		System.out.println("[AlimTalkLogDatabase:selectByFilter()]"+ query);

            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTalkLogBean alimTalkLog = new AlimTalkLogBean();
                alimTalkLog.setTemplate_code(rs.getString("TEMPLATE_CODE"));
                alimTalkLog.setDate_client_req(rs.getTimestamp("DATE_CLIENT_REQ"));
                alimTalkLog.setContent(rs.getString("CONTENT"));
                alimTalkLog.setCallback(rs.getString("CALLBACK"));
                alimTalkLog.setRecipient_num(rs.getString("RECIPIENT_NUM"));
                alimTalkLog.setReport_code(rs.getString("REPORT_CODE"));
                alimTalkLog.setUserNm(rs.getString("USER_NM"));
                alimTalkLog.setFirmNm(rs.getString("FIRM_NM"));

                alimTalkLogs.add(alimTalkLog);
            }
            rs.close();
            pstmt.close();
        }
        catch (Exception e) {
            e.printStackTrace();
			System.out.println("[AlimTalkLogDatabase:selectByFilter()]"+ e);
			System.out.println("[AlimTalkLogDatabase:selectByFilter()]"+ query);
        } finally {
            try {
                if(rs != null )
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
            }
            catch(Exception ignore){ }
            closeConnection();

            return alimTalkLogs;
        }
    }


    // 로그 가져오기 (필터 검색)
    public List<AlimTalkLogBean> selectByFilterEm(String code, String dateType, String startDate, String endDate,
                                                String searchType, String searchKeyword) {
        ArrayList<AlimTalkLogBean> alimTalkLogs = new ArrayList<AlimTalkLogBean>();

        // 1. 현재달 기준으로 6개월치 테이블 이름
        List<String> tables = getLogTableNameEm();

        // 테이블이 없으면
        if (tables.size() == 0) {
            return alimTalkLogs;
        }

        String where = "WHERE A.ETC_TEXT_2 = U.USER_ID(+) and  A.ETC_TEXT_1 = C. rent_l_cd(+) ";		

        // 템플릿 코드
        if (code.equals("") == false) {
            //where += "AND A.TEMPLATE_CODE = '" + code + "' ";
        }

        // 당월
        if (dateType.equals("4")) {
            where += "AND TRUNC(A.DATE_CLIENT_REQ, 'MONTH') = TRUNC(SYSDATE, 'MONTH') ";
        }
        // 전월
        else if (dateType.equals("5")) {
            where += "AND TRUNC(A.DATE_CLIENT_REQ, 'MONTH') = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MONTH') ";
        }
        // 당일
        else if (dateType.equals("1")) {
            where += "AND TRUNC(A.DATE_CLIENT_REQ) = TO_DATE(SYSDATE) ";
        }
        // 전일
        else if (dateType.equals("2")) {
            where += "AND TRUNC(A.DATE_CLIENT_REQ) = TO_DATE(SYSDATE - 1) ";
        }
        // 2일
        else if (dateType.equals("3")) {
            where += "AND (TRUNC(A.DATE_CLIENT_REQ) = TO_DATE(SYSDATE) OR TRUNC(A.DATE_CLIENT_REQ) = TO_DATE(SYSDATE - 1)) ";
        }
        // 기간
        else if (dateType.equals("6")) {
            //if (!startDate.equals("") && !endDate.equals("")) {
            //    where += "AND TRUNC(A.DATE_CLIENT_REQ) BETWEEN TO_DATE(" + startDate + ", 'YYYYMMDD') AND TO_DATE(" + endDate + ", 'YYYYMMDD') ";
            //}
//						System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ startDate);
//						System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ endDate);
        }

        if (!searchKeyword.equals("")) {
            // 계약번호
            if (searchType.equals("1")) {
                where += "AND A.ETC_TEXT_1 = '" + searchKeyword + "' ";
            }
            // 발신자
            if (searchType.equals("2")) {
                where += "AND U.USER_NM = '" + searchKeyword + "' ";
            }
            // 발신번호
            if (searchType.equals("3")) {
                where += "AND A.CALLBACK = '" + searchKeyword + "' ";
            }
            // 수신번호
            if (searchType.equals("4")) {
                where += "AND A.RECIPIENT_NUM = '" + searchKeyword + "' ";
            }
            // 문자내용
            if (searchType.equals("5")) {
                where += "AND A.CONTENT like '%" + searchKeyword + "%' ";
            }
        }

        String query =
                "SELECT a.* , nvl(b.firm_nm, '-') firm_nm   FROM ( ";


		if (dateType.equals("6") && AddUtil.parseInt(startDate+""+endDate) >= 201710 ) {

	        query +=
		            "SELECT A.DATE_CLIENT_REQ, A.CONTENT, A.CALLBACK, A.RECIPIENT_NUM, A.MT_REPORT_CODE_IB, U.USER_NM, c.client_id FROM EM_MMT_LOG_"+startDate+""+endDate+" A, amazoncar.USERS U, amazoncar.cont c " + where + " ";
	        query +=
		            "UNION " + "SELECT A.DATE_CLIENT_REQ, A.CONTENT, A.CALLBACK, A.RECIPIENT_NUM, A.MT_REPORT_CODE_IB, U.USER_NM, c.client_id FROM EM_SMT_LOG_"+startDate+""+endDate+" A, amazoncar.USERS U, amazoncar.cont c " + where + " ";

		}else{

	        query +=
		            "SELECT A.DATE_CLIENT_REQ, A.CONTENT, A.CALLBACK, A.RECIPIENT_NUM, A.MT_REPORT_CODE_IB, U.USER_NM, c.client_id FROM " + tables.get(0) + " A, amazoncar.USERS U, amazoncar.cont c " + where + " ";
			for (int i = 1; i < tables.size(); i++) {
				query +=
	                    "UNION " + "SELECT A.DATE_CLIENT_REQ, A.CONTENT, A.CALLBACK, A.RECIPIENT_NUM, A.MT_REPORT_CODE_IB, U.USER_NM, c.client_id FROM " + tables.get(i) + " A, amazoncar.USERS U, amazoncar.cont c  " + where + " ";
		    }

		}



        query +=
                ") a,  amazoncar.client b where a.client_id = b.client_id(+) ";

        if (!searchKeyword.equals("")) {
            // 상호
            if (searchType.equals("6")) {
                where += "AND b.firm_nm like '%" + searchKeyword + "%' ";
            }

        }
		
		query += " ORDER BY a.DATE_CLIENT_REQ DESC";

        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
//			System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ query);

			pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTalkLogBean alimTalkLog = new AlimTalkLogBean();
                alimTalkLog.setDate_client_req(rs.getTimestamp("DATE_CLIENT_REQ"));
                alimTalkLog.setContent(rs.getString("CONTENT"));
                alimTalkLog.setCallback(rs.getString("CALLBACK"));
                alimTalkLog.setRecipient_num(rs.getString("RECIPIENT_NUM"));
                alimTalkLog.setReport_code(rs.getString("MT_REPORT_CODE_IB"));
                alimTalkLog.setUserNm(rs.getString("USER_NM"));
                alimTalkLog.setFirmNm(rs.getString("FIRM_NM"));

                alimTalkLogs.add(alimTalkLog);
            }
            rs.close();
            pstmt.close();
        }
        catch (Exception e) {
            e.printStackTrace();
			System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ e);
			System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ query);
        } finally {
            try {
                if(rs != null )
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
            }
            catch(Exception ignore){ }
            closeConnection();

            return alimTalkLogs;
        }
    }
    
 // 로그 가져오기 (담당자, 파트너로 검색)
    public List<AlimTalkLogBean> selectByBondEm(String type, String rent_l_cd, String bus_id, String partner_id) {
        ArrayList<AlimTalkLogBean> alimTalkLogs = new ArrayList<AlimTalkLogBean>();

       /*
        	type 1 = 계약번호로 검색
        	type 2 = 담당자, 파트너로 검색
       */
        
        // 1. 현재달 기준으로 6개월치 테이블 이름
        List<String> tables = getLogTableNameEm();

        // 테이블이 없으면
        if (tables.size() == 0) {
            return alimTalkLogs;
        }

        String where = "WHERE A.ETC_TEXT_2 = U.USER_ID(+) and  A.ETC_TEXT_1 = C. rent_l_cd(+) ";
        
        if (type.equals("1")) {
        	where += "AND A.ETC_TEXT_1 = '"+rent_l_cd+"' ";
        } else if (type.equals("2")) {
        	where += "AND ( A.ETC_TEXT_2 = '"+bus_id+"' OR A.ETC_TEXT_2 = '"+partner_id+"' ) ";
        }
        
        String query =
                "SELECT a.* , nvl(b.firm_nm, '-') firm_nm , Nvl(c.user_nm, '-') user_nm2  FROM ( ";
        
        query +=
	            "SELECT A.DATE_CLIENT_REQ, A.CONTENT, A.CALLBACK, A.RECIPIENT_NUM, A.MT_REPORT_CODE_IB, U.USER_NM, c.client_id FROM " + tables.get(0) + " A, amazoncar.USERS U, amazoncar.cont c " + where + " ";
		for (int i = 1; i < tables.size(); i++) {
			query +=
                    "UNION " + "SELECT A.DATE_CLIENT_REQ, A.CONTENT, A.CALLBACK, A.RECIPIENT_NUM, A.MT_REPORT_CODE_IB, U.USER_NM, c.client_id FROM " + tables.get(i) + " A, amazoncar.USERS U, amazoncar.cont c  " + where + " ";
	    }

        query +=
                ") a,  amazoncar.client b, amazoncar.users c where a.client_id = b.client_id(+) AND a.RECIPIENT_NUM = c.user_m_tel(+) ";
		
		query += " ORDER BY a.DATE_CLIENT_REQ DESC";

        getConnection();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ query);
        try {

			pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                AlimTalkLogBean alimTalkLog = new AlimTalkLogBean();
                alimTalkLog.setDate_client_req(rs.getTimestamp("DATE_CLIENT_REQ"));
                alimTalkLog.setContent(rs.getString("CONTENT"));
                alimTalkLog.setCallback(rs.getString("CALLBACK"));
                alimTalkLog.setRecipient_num(rs.getString("RECIPIENT_NUM"));
                alimTalkLog.setReport_code(rs.getString("MT_REPORT_CODE_IB"));
                alimTalkLog.setUserNm(rs.getString("USER_NM"));
                alimTalkLog.setUserNm2(rs.getString("USER_NM2"));
                alimTalkLog.setFirmNm(rs.getString("FIRM_NM"));

                alimTalkLogs.add(alimTalkLog);
            }
            rs.close();
            pstmt.close();
        }
        catch (Exception e) {
            e.printStackTrace();
			System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ e);
			System.out.println("[AlimTalkLogDatabase:selectByFilterEm()]"+ query);
        } finally {
            try {
                if(rs != null )
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
            }
            catch(Exception ignore){ }
            closeConnection();

            return alimTalkLogs;
        }
    }
    
    /**
	 * 동일한 고객에게 전송한 알림톡 내용이 일치하는지 확인한다.
	 * 2018.03.13
	 * 2020.10.05 수정(kakao DB계정 변경으로 ConsignmentDatabase.java 에서 이동)
	 */
	public String checkAlimTalk(String table_name, String etc_text_1, String recipient_num){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = "";
		String query = "";
		
		query = " select content from "+table_name+" where etc_text_1 = '"+etc_text_1+"' and recipient_num = '"+recipient_num+"' ";
		//System.out.println("query : " + query);
		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
			if(rs.next())
			{
				result = rs.getString("content");
			}
			rs.close();
			pstmt.close();
			System.out.println("[AlimTalkLogDatabase:checkAlimTalk]\n"+query);
		} catch (SQLException e) {
			System.out.println("[AlimTalkLogDatabase:checkAlimTalk]\n"+e);
			e.printStackTrace();
		} finally {
			try{
            if(rs != null )		rs.close();
            if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

}
