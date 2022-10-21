/**
 * 차명관리
 */
package acar.car_mst;

import java.util.*;
import java.sql.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

public class AddCarMstDatabase {

    private static AddCarMstDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 

    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized AddCarMstDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AddCarMstDatabase();
        return instance;
    }
    
    private AddCarMstDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

	
    /**
	 *	코드 리스트()
	 */
	public Vector getSearchCode(String car_comp_id, String code, String car_id, String view_dt, String mode, String a_a) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(mode.equals("1")){//차종코드 리스트

			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('마이티Ⅱ','포터')";
			
			query += " ORDER BY CAR_NM";

		}else if(mode.equals("2")){//차명 리스트-차종으로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt >='20040101' ORDER BY jg_code, car_b_p";

		}else if(mode.equals("3")){//기준월 리스트

			query = " select DISTINCT car_b_dt from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'  ORDER BY car_b_dt desc ";

		}else if(mode.equals("4")){//차명 리스트-기준월로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt =replace('"+view_dt+"', '-', '') ORDER BY jg_code, car_b_p";

		}else if(mode.equals("10")){//차명 리스트-기준월로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt =replace('"+view_dt+"', '-', '') ORDER BY jg_code, car_b_p";

		}else if(mode.equals("5")){//선택사양 - 기준월 리스트

			query = " select DISTINCT car_s_dt from CAR_SEL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("9")){//선택사양 - 기준월 리스트

			query = " select DISTINCT car_s_dt from CAR_OPT where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and car_id='"+car_id+"'";

		}else if(mode.equals("6")){//색상 - 기준월 리스트

			query = " select DISTINCT car_c_dt from CAR_COL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("12")){//색상 - 기준월 리스트 2

			query = " select DISTINCT car_u_seq, car_c_dt from CAR_COL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

			query += " ORDER BY car_u_seq";

		}else if(mode.equals("13")){//색상 - 기준월 리스트 마지막

			query = " select max(car_u_seq) car_u_seq from CAR_COL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";


//		}else if(mode.equals("18")){//색상 - 기준월 리스트 마지막

//			query = " select car_k_dt from CAR_KM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and car_k_dt='"+view_dt+"'";


		}else if(mode.equals("7")){//제조사DC - 기준월 리스트

			query = " select DISTINCT car_d_dt from CAR_DC where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("14")){//제조사DC 리스트

			query = " select DISTINCT car_b_dt, car_seq from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' group by car_b_dt ORDER BY car_b_dt desc ";

		}else if(mode.equals("8")){//차종코드 리스트-견적여부

			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y' and nvl(est_yn,'Y')='Y' and nvl(main_yn,'Y')='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('SUT무쏘','마이티Ⅱ','포터')";


			//도요타 : 캠리 -> [20140922] 라브4 추가
			//if(car_comp_id.equals("0007"))	query += " and code in ('03','02')";
            //BMW    : 520d, 528i, 320d -> [20131104] GT30d, GT20d, 730d 추가 -> [20131209] 525d, 740d 추가 -> [20140313] X5 추가 -> [20140416] X3, X6 -> [20140922] 320d GT, 530d , 118d[20150813]
			//if(car_comp_id.equals("0013"))	query += " and code in ('16','17','18','20','22','21','19','24','13','15','25','27','23', '30' )";
			//메르세데스-벤츠 : E300, C220 CDI, E220 CDI -> [20130701] C220 CDI, The new E220 CDI, The new E250 CDI, The new E300 -> [20131104] CLS350 추가 -> [20131121] S350 추가 -> [20131126] S500 추가 -> [20140416] CLA200, CLS250, GLK220 -> [20140610] C200, C220 -> [20140922] A180 CDI, ML350, GLA 200CDI -> [20141120] The new E250 BlueTEC -> [20141223] The new E220 BlueTEC  -> [20150107] The new E350 BlueTEC, CLS250 BlueTEC 
			//the  new c250[20150813]
			//if(car_comp_id.equals("0027"))	query += " and code in ('06','08','09','10','13','14','15','18','19','12','20','21','22','16','23','24','25','26','27', '30')";
			//아우디자동차 : A6, A4 -> [20131104] A7, A8, Q5, Q3, A5 추가 -> [20140313] A3 추가 -> [20150527] The new A6, The new A7 추가  -> [20150528] The new Q3 추가 
			//if(car_comp_id.equals("0018"))	query += " and code in ('08','01','09','04','10','11','12','13','14','15','16')";
			//렉서스 : ES350
			//if(car_comp_id.equals("0044"))	query += " and code in ('01')";
			//폭스바겐 : 파사트, 티구안 -> [20130701] CC 추가, [20130906]골프 추가 -> [20131104] 제타 추가 -> [20140416] 폴로
			//if(car_comp_id.equals("0011"))	query += " and code in ('05','06','07','09','08','10')";
			//포드 : 토러스, 익스플로러 [20130906] , mondeo[20150813]
			//if(car_comp_id.equals("0021"))	query += " and code in ('08','09', '04')";
			//닛산 : 알티마, 캐시카이[20150813]
			//if(car_comp_id.equals("0033"))	query += " and code in ('02', '04')";
			//혼다 : 어코드, CR-V
			//if(car_comp_id.equals("0025"))	query += " and code in ('01','02')";
			//지프 : 그랜드체로키
			//if(car_comp_id.equals("0047"))	query += " and code in ('02')";
			//인피니티 : Q50
			//if(car_comp_id.equals("0048"))	query += " and code in ('01')";
			//푸조 : 208 -> [20140922] 뉴308 -> [20141104] 2008
			//if(car_comp_id.equals("0034"))	query += " and code in ('04','05','06')";
			//랜드로버 : 레인지로버 -> [20140922] 디스커버리4
			//if(car_comp_id.equals("0049"))	query += " and code in ('01','02')";
			//볼보 : S60
			//if(car_comp_id.equals("0006"))	query += " and code in ('48')";
			//미니 : The new 미니쿠퍼, 컨트리맨
			//if(car_comp_id.equals("0050"))	query += " and code in ('01','02')";
			//링컨 : MKZ
			//if(car_comp_id.equals("0051"))	query += " and code in ('01')";
			//재규어 : XE 
			//if(car_comp_id.equals("0052"))	query += " and code in ('02')";
			
			query += " ORDER BY CAR_NM";

		}else if(mode.equals("11")){//중고차 차종코드 리스트

			query = " select a.jg_code, max(b.cars) cars from CAR_NM a, esti_jg_var b where a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+code+"' and a.jg_code=b.sh_code group by a.jg_code ";
			
			query += " ORDER BY a.jg_code";

		}else{
			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('마이티Ⅱ','포터')";
			
			query += " ORDER BY CAR_NM";
		}

	
		try {
		    pstmt = con.prepareStatement(query);
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
		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getSearchCode]"+e);
			System.out.println("[AddCarMstDatabase:getSearchCode]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	코드 리스트()
	 */
	public Vector getSearchCode(String car_comp_id, String code, String car_id, String view_dt, String mode, String a_a, String gubun1, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(mode.equals("1")){//차종코드 리스트

			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('마이티Ⅱ','포터')";
			
			query += " ORDER BY use_yn desc, CAR_NM";

		}else if(mode.equals("2")){//차명 리스트-차종으로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt >='20040101' ORDER BY jg_code, car_b_p";

		}else if(mode.equals("3")){//기준월 리스트

			query = " select car_b_dt, COUNT(DECODE(use_yn,'Y',car_id)) cnt from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'  group by car_b_dt ORDER BY car_b_dt desc ";

		}else if(mode.equals("4")){//차명 리스트-기준월로

			query = " select DISTINCT car_id, car_name from (select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' ";

			if(!view_dt.equals("") && !view_dt.equals("99999999"))		query += " and car_b_dt =replace('"+view_dt+"', '-', '') ";

			if(gubun1.equals("Y"))		query += " and use_yn='Y'";
			if(gubun1.equals("N"))		query += " and use_yn='N'";

			//검색일경우 해약건에대한 정렬위해
			String sort = asc.equals("0")?" asc":" desc";
			/*정렬조건*/
			if(sort_gubun.equals("1"))		query += " order by car_name "+sort+" ";
			else if(sort_gubun.equals("2"))	query += " order by jg_code "+sort+", car_b_p ";
			else if(sort_gubun.equals("3"))	query += " order by car_b_p "+sort+", substr(jg_code,1,3) ";
			else if(sort_gubun.equals("4"))	query += " order by car_b_dt "+sort+", substr(jg_code,1,3), car_b_p ";
			else							query += " order by jg_code, car_b_p ";

			query += " ) ";

		}else if(mode.equals("10")){//차명 리스트-기준월로
		
			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' ";

			if(!view_dt.equals("") && !view_dt.equals("99999999"))		query += " and car_b_dt =replace('"+view_dt+"', '-', '') ";

			if(gubun1.equals("Y"))		query += " and use_yn='Y'";
			if(gubun1.equals("N"))		query += " and use_yn='N'";

			//검색일경우 해약건에대한 정렬위해
			String sort = asc.equals("0")?" asc":" desc";
			/*정렬조건*/
			if(sort_gubun.equals("1"))		query += " order by car_name "+sort+" ";
			else if(sort_gubun.equals("2"))	query += " order by jg_code "+sort+", car_b_p ";
			else if(sort_gubun.equals("3"))	query += " order by car_b_p "+sort+", substr(jg_code,1,3) ";
			else if(sort_gubun.equals("4"))	query += " order by car_b_dt "+sort+", substr(jg_code,1,3), car_b_p ";
			else							query += " order by jg_code, car_b_p ";

		}else if(mode.equals("5")){//선택사양 - 기준월 리스트

			query = " select DISTINCT car_s_dt from CAR_SEL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("9")){//선택사양 - 기준월 리스트

			query = " select DISTINCT car_s_dt from CAR_OPT where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and car_id='"+car_id+"'";

		}else if(mode.equals("6")){//색상 - 기준월 리스트

			query = " select DISTINCT car_c_dt from CAR_COL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("12")){//색상 - 기준월 리스트 2

			query = " select DISTINCT car_u_seq, car_c_dt from CAR_COL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

			if(!view_dt.equals("") && !view_dt.equals("99999999"))		query += " and car_c_dt =replace('"+view_dt+"', '-', '') ";

//			if(view_dt.equals(""))		query += " and use_yn ='Y' ";

			query += " ORDER BY car_u_seq, car_c_dt desc";
			
		}else if(mode.equals("16")){//기준월 리스트

			query = " select car_k_dt, COUNT(DECODE(use_yn,'Y',car_cd)) cnt from CAR_KM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'  group by car_k_dt ORDER BY car_k_dt desc ";

		}else if(mode.equals("13")){//색상 - 기준월 리스트 마지막

			query = " select max(car_u_seq) car_u_seq from CAR_COL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";


		}else if(mode.equals("7")){//제조사DC - 기준월 리스트

			query = " select DISTINCT car_d_dt from CAR_DC where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("14")){//제조사DC 리스트

			query = " select DISTINCT car_b_dt, car_seq from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' group by car_b_dt ORDER BY car_b_dt desc ";

		}else if(mode.equals("8")){//차종코드 리스트-견적여부

			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y' and nvl(est_yn,'Y')='Y' and nvl(main_yn,'Y')='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('SUT무쏘','마이티Ⅱ','포터')";

			//도요타 : 캠리 -> [20140922] 라브4 추가
			//if(car_comp_id.equals("0007"))	query += " and code in ('03','02')";
            //BMW    : 520d, 528i, 320d -> [20131104] GT30d, GT20d, 730d 추가 -> [20131209] 525d, 740d 추가 -> [20140313] X5 추가 -> [20140416] X3, X6 -> [20140922] 320d GT, 530d, 118d[20150813]
			//if(car_comp_id.equals("0013"))	query += " and code in ('16','17','18','20','22','21','19','24','13','15','25','27','23', '30')";
			//메르세데스-벤츠 : E300, C220 CDI, E220 CDI -> [20130701] C220 CDI, The new E220 CDI, The new E250 CDI, The new E300 -> [20131104] CLS350 추가 -> [20131121] S350 추가 -> [20131126] S500 추가 -> [20140416] CLA200, CLS250, GLK220 -> [20140610] C200, C220 -> [20140922] A180 CDI, ML350, GLA 200CDI -> [20141120] The new E250 BlueTEC -> [20141223] The new E220 BlueTEC  -> [20150107] The new E350 BlueTEC, CLS250 BlueTEC 
				//the  new c250[20150813]
			//if(car_comp_id.equals("0027"))	query += " and code in ('06','08','09','10','13','14','15','18','19','12','20','21','22','16','23','24','25','26','27', '30')";
			//아우디자동차 : A6, A4 -> [20131104] A7, A8, Q5, Q3, A5 추가 -> [20140313] A3 추가 -> [20150527] The new A6, The new A7 추가  -> [20150528] The new Q3 추가 
			//if(car_comp_id.equals("0018"))	query += " and code in ('08','01','09','04','10','11','12','13','14','15','16')";
			//렉서스 : ES350
			//if(car_comp_id.equals("0044"))	query += " and code in ('01')";
			//폭스바겐 : 파사트, 티구안 -> [20130701] CC 추가, [20130906]골프 추가 -> [20131104] 제타 추가 -> [20140416] 폴로
			//if(car_comp_id.equals("0011"))	query += " and code in ('05','06','07','09','08','10')";
			//포드 : 토러스, 익스플로러 [20130906],  mondeo[20150813]
			//if(car_comp_id.equals("0021"))	query += " and code in ('08','09', '04')";
			//닛산 : 알티마, 캐시카이[20150813]
			//if(car_comp_id.equals("0033"))	query += " and code in ('02', '04')";
			//혼다 : 어코드, CR-V
			//if(car_comp_id.equals("0025"))	query += " and code in ('01','02')";
			//지프 : 그랜드체로키
			//if(car_comp_id.equals("0047"))	query += " and code in ('02')";
			//인피니티 : Q50
			//if(car_comp_id.equals("0048"))	query += " and code in ('01')";
			//푸조 : 208 -> [20140922] 뉴308 -> [20141104] 2008
			//if(car_comp_id.equals("0034"))	query += " and code in ('04','05','06')";
			//랜드로버 : 레인지로버 -> [20140922] 디스커버리4
			//if(car_comp_id.equals("0049"))	query += " and code in ('01','02')";
			//볼보 : S60
			//if(car_comp_id.equals("0006"))	query += " and code in ('48')";
			//미니 : The new 미니쿠퍼, 컨트리맨
			//if(car_comp_id.equals("0050"))	query += " and code in ('01','02')";
			//링컨 : MKZ
			//if(car_comp_id.equals("0051"))	query += " and code in ('01')";
			//재규어 : XE 
			//if(car_comp_id.equals("0052"))	query += " and code in ('02')";

			
			query += " ORDER BY CAR_NM";

		}else if(mode.equals("11")){//중고차 차종코드 리스트

			query = " select a.jg_code, max(b.cars) cars from CAR_NM a, esti_jg_var b where a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+code+"' and a.jg_code=b.sh_code group by a.jg_code ";
			
			query += " ORDER BY a.jg_code";

		}else if(mode.equals("15")){//조정잔가 리스트

			query = " SELECT distinct a.* "+
		            " FROM   car_nm c, esti_jg_opt_var a, ( select sh_code, max(reg_dt) reg_dt from esti_jg_opt_var GROUP BY sh_code ) b "+
			        " WHERE  c.car_id='"+car_id+"' and c.jg_code=a.sh_code AND a.sh_code=b.sh_code AND a.reg_dt=b.reg_dt "+
				    " ORDER BY a.jg_opt_st ";

		}else{
			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('마이티Ⅱ','포터')";
			
			query += " ORDER BY CAR_NM";
		}

	
//System.out.println("[AddCarMstDatabase:getSearchCode]"+query);			

		try {
		    pstmt = con.prepareStatement(query);
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
		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getSearchCode]"+e);
			System.out.println("[AddCarMstDatabase:getSearchCode]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll(String car_comp_id, String code, String car_id, String view_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.CAR_B_INC_ID, c.CAR_B_INC_SEQ "+
				" FROM car_mng a, code b, car_nm c"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001'";// and c.car_b_dt>='20040101'// and c.est_yn='Y'

		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"'";
		if(!code.equals(""))		query += " and c.car_cd = '"+code+"'";
		if(!car_id.equals(""))		query += " and c.car_id = '"+car_id+"'";
		if(!view_dt.equals(""))		query += " and c.car_b_dt = '"+view_dt+"'";
		if(view_dt.equals(""))		query += " and c.car_b_dt>='20040101'";

		query += " order by c.car_name ";


        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));
				bean.setCar_b_inc_id(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq(rs.getString("CAR_B_INC_SEQ"));

				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }

    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll2(String car_comp_id, String code, String car_id, String view_dt, String t_wd, String t_wd2, String t_wd3, String t_wd4, String gubun1) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.CAR_B_INC_ID, c.CAR_B_INC_SEQ, c.est_yn, c.s_st, c.jg_code "+
				" FROM car_mng a, code b, car_nm c"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001'";// and c.car_b_dt>='20040101'

		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"'";
		if(!code.equals(""))		query += " and c.car_cd = '"+code+"'";
		if(!car_id.equals(""))		query += " and c.car_id = '"+car_id+"'";
		if(!view_dt.equals(""))		query += " and c.car_b_dt = '"+view_dt+"'";
		if(view_dt.equals(""))		query += " and c.car_b_dt>='20040101'";
		if(!t_wd.equals(""))		query += " and a.car_nm||c.car_name like '%"+t_wd+"%"+t_wd2+"%"+t_wd3+"%'";
		if(!t_wd4.equals(""))		query += " and c.car_b_p like '%"+t_wd4+"%'";
		if(gubun1.equals("Y"))		query += " and c.use_yn='Y'";
		if(gubun1.equals("N"))		query += " and c.use_yn='N'";

		query += " order by c.car_name ";



        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));
				bean.setCar_b_inc_id(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq(rs.getString("CAR_B_INC_SEQ"));
				bean.setEst_yn(rs.getString("EST_YN"));
				bean.setJg_code(rs.getString("JG_CODE"));
				bean.setS_st(rs.getString("S_ST"));

				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }

    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll(String car_comp_id, String code, String car_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT"+
				" FROM car_mng a, code b, car_nm c,"+
				" (select car_comp_id, car_cd, car_id, max(car_seq) car_seq from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id) d"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001'"+
				" and c.car_comp_id=d.car_comp_id(+) and c.car_cd=d.car_cd(+) and c.car_id=d.car_id(+) and c.car_seq=d.car_seq(+)"+
				" and c.car_b_dt>='20040101'";// and c.est_yn='Y'

		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"'";
		if(!code.equals(""))		query += " and a.car_cd = '"+code+"'";
		if(!car_id.equals(""))		query += " and c.car_id = '"+car_id+"'";

		query += " order by car_nm, car_name, c.car_b_p";

        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));

				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }

    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll(String car_comp_id, String code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT"+
				" FROM car_mng a, code b, car_nm c,"+
				" (select car_comp_id, car_cd, car_id, max(car_seq) car_seq from car_nm  group by car_comp_id, car_cd, car_id) d"+//where use_yn='Y'
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001'"+
				" and c.car_comp_id=d.car_comp_id and c.car_cd=d.car_cd and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				" and c.car_b_dt>='20040101'";

		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"'";
		if(!code.equals(""))		query += " and c.car_cd = '"+code+"'";

		query += " order by c.car_b_p";

        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));

				col.add(bean); 
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }
    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll2(String car_comp_id, String code, String t_wd, String t_wd2, String t_wd3, String t_wd4, String gubun1) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, C.est_yn, C.car_b_inc_id, C.car_b_inc_seq, c.s_st, c.jg_code"+
				" FROM car_mng a, code b, car_nm c,"+
				" (select car_comp_id, car_cd, car_id, max(car_seq) car_seq from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id) d"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001'"+
				" and c.car_comp_id=d.car_comp_id and c.car_cd=d.car_cd and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				" and c.car_b_dt>='20040101' ";

		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"'";
		if(!code.equals(""))		query += " and c.car_cd = '"+code+"'";
		if(!t_wd.equals(""))		query += " and a.car_nm||c.car_name like '%"+t_wd+"%"+t_wd2+"%"+t_wd3+"%'";
		if(!t_wd4.equals(""))		query += " and c.car_b_p like '%"+t_wd4+"%'";
//		if(gubun1.equals("Y"))		query += " and c.use_yn='Y'";
//		if(gubun1.equals("N"))		query += " and c.use_yn='N'";

		query += " order by c.car_b_p";

        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));
				bean.setEst_yn(rs.getString("EST_YN"));
				bean.setCar_b_inc_id(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq(rs.getString("CAR_B_INC_SEQ"));
				bean.setS_st(rs.getString("S_ST"));
				bean.setJg_code(rs.getString("JG_CODE"));

				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }
    
	/**
     * 차명 한건 조회.
     */
    public CarMstBean getCarNmCase(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        CarMstBean bean = new CarMstBean();
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				"        a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				"        c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.dpm, c.max_le_36, c.max_le_24, c.max_le_12, c.max_re_36, c.max_re_24, c.max_re_18,"+
				"        c.s_st, c.est_yn, c.car_b_inc_id, c.car_b_inc_seq, sh_code, diesel_yn, auto_yn, c.jg_code, "+
				"        c.air_ds_yn, c.air_as_yn, c.air_cu_yn, c.abs_yn, c.rob_yn, c.sp_car_yn, c.end_dt, "+
				"        c.car_b_p2, c.r_dc_amt, c.l_dc_amt, c.r_cash_back, c.l_cash_back, c.r_card_amt, c.l_card_amt, c.r_bank_amt, c.l_bank_amt, c.etc, c.car_y_form, "+
				"        c.hp_yn, c.jg_tuix_st, c.lkas_yn, c.ldws_yn, c.aeb_yn, c.fcw_yn, c.etc2, c.car_y_form2, c.car_y_form3, c.duty_free_opt, "+	//개소세 면세가/과세가 추가(20190429)
				"		 c.car_y_form_yn, c.garnish_yn, c.hook_yn, a.dlv_ext  \n"+
				" FROM   car_mng a, code b, car_nm c"+
				" where  a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				"        and a.car_comp_id=b.code and b.c_st = '0001'";

		if(!car_id.equals("") && !car_seq.equals(""))	query += " and c.car_id = '"+car_id+"' and c.car_seq = '"+car_seq+"'";
		if(!car_id.equals("") &&  car_seq.equals(""))	query += " and c.car_id = '"+car_id+"' and c.use_yn='Y' and c.car_b_dt = (select max(car_b_dt) from car_nm where car_id='"+car_id+"')";
		if(car_id.equals("")  &&  car_seq.equals(""))	query += " and c.car_id = '"+car_id+"' and c.car_seq = '"+car_seq+"'";

		query += " order by c.car_name";
		

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
			    bean.setCar_comp_id			(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm			(rs.getString("CAR_COMP_NM"));
			    bean.setCode				(rs.getString("CODE"));
				bean.setCar_cd				(rs.getString("CAR_CD"));
			    bean.setCar_nm				(rs.getString("CAR_NM"));
			    bean.setCar_id				(rs.getString("CAR_ID"));
			    bean.setCar_name			(rs.getString("CAR_NAME"));
				bean.setCar_yn				(rs.getString("CAR_YN"));
				bean.setSection				(rs.getString("SECTION"));
			    bean.setCar_seq				(rs.getString("CAR_SEQ"));
				bean.setCar_b				(rs.getString("CAR_B"));
				bean.setCar_b_p				(rs.getInt   ("CAR_B_P"));
				bean.setCar_b_dt			(rs.getString("CAR_B_DT"));
				bean.setDpm					(rs.getInt   ("DPM"));
				bean.setMax_le_36			(rs.getInt   ("MAX_LE_36"));
				bean.setMax_le_24			(rs.getInt   ("MAX_LE_24"));
				bean.setMax_le_12			(rs.getInt   ("MAX_LE_12"));
				bean.setMax_re_36			(rs.getInt   ("MAX_RE_36"));
				bean.setMax_re_24			(rs.getInt   ("MAX_RE_24"));
				bean.setMax_re_18			(rs.getInt   ("MAX_RE_18"));
				bean.setS_st				(rs.getString("S_ST"));
				bean.setEst_yn				(rs.getString("EST_YN"));
				bean.setCar_b_inc_id		(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq		(rs.getString("CAR_B_INC_SEQ"));
				bean.setSh_code				(rs.getString("SH_CODE"));
				bean.setDiesel_yn			(rs.getString("DIESEL_YN"));
				bean.setAuto_yn				(rs.getString("AUTO_YN"));
				bean.setJg_code				(rs.getString("JG_CODE"));
				bean.setAir_ds_yn			(rs.getString("air_ds_yn")==null?"":rs.getString("air_ds_yn"));
				bean.setAir_as_yn			(rs.getString("air_as_yn")==null?"":rs.getString("air_as_yn"));
				bean.setAir_cu_yn			(rs.getString("air_cu_yn")==null?"":rs.getString("air_cu_yn"));
				bean.setAbs_yn				(rs.getString("abs_yn")==null?"":rs.getString("abs_yn"));
				bean.setRob_yn				(rs.getString("rob_yn")==null?"":rs.getString("rob_yn"));
				bean.setSp_car_yn			(rs.getString("sp_car_yn")==null?"":rs.getString("sp_car_yn"));
				bean.setEnd_dt				(rs.getString("end_dt")==null?"N":rs.getString("end_dt"));
				bean.setCar_b_p2			(rs.getInt   ("car_b_p2"));
				bean.setR_dc_amt			(rs.getInt   ("r_dc_amt"));
				bean.setL_dc_amt			(rs.getInt   ("l_dc_amt"));
				bean.setR_cash_back			(rs.getInt   ("r_cash_back"));
				bean.setL_cash_back			(rs.getInt   ("l_cash_back"));
				bean.setR_card_amt			(rs.getInt   ("r_card_amt"));
				bean.setL_card_amt			(rs.getInt   ("l_card_amt"));
				bean.setR_bank_amt			(rs.getInt   ("r_bank_amt"));
				bean.setL_bank_amt			(rs.getInt   ("l_bank_amt"));
				bean.setEtc					(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setCar_y_form			(rs.getString("car_y_form")==null?"":rs.getString("car_y_form"));
				bean.setHp_yn				(rs.getString("hp_yn")==null?"":rs.getString("hp_yn"));
				bean.setJg_tuix_st			(rs.getString("jg_tuix_st")==null?"":rs.getString("jg_tuix_st"));
				bean.setLkas_yn				(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn				(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn				(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn				(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setGarnish_yn			(rs.getString("garnish_yn")==null?"":rs.getString("garnish_yn"));	//가니쉬
				bean.setHook_yn				(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));	//견인고리
				bean.setEtc2				(rs.getString("etc2")==null?"":rs.getString("etc2")); 	//기타 추가(2018.02.08)
				bean.setCar_y_form2			(rs.getString("car_y_form2")==null?"":rs.getString("car_y_form2"));
				bean.setCar_y_form3			(rs.getString("car_y_form3")==null?"":rs.getString("car_y_form3"));
				bean.setDuty_free_opt		(rs.getString("duty_free_opt")==null?"":rs.getString("duty_free_opt"));	//개소세 면세가/과세가 표기(20190429)
				bean.setCar_y_form_yn		(rs.getString("car_y_form_yn")==null?"":rs.getString("car_y_form_yn"));	//신차견적서 연형표기여부(20190610)
				bean.setDlv_ext		        (rs.getString("dlv_ext")==null?"":rs.getString("dlv_ext")); //차종별기본출고지
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 System.out.println(car_id);
			 System.out.println(car_seq);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 차명 한건 조회.
     */
    public CarMstBean getCarNmCase2(String car_id, String car_seq, String car_b_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        CarMstBean bean = new CarMstBean();
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.dpm, c.max_le_36, c.max_le_24, c.max_le_12, c.max_re_36, c.max_re_24, c.max_re_18,"+
				" c.s_st, c.est_yn, c.car_b_inc_id, c.car_b_inc_seq, sh_code, diesel_yn, auto_yn, c.jg_code, "+
				" c.air_ds_yn, c.air_as_yn, c.air_cu_yn, c.abs_yn, c.rob_yn, c.sp_car_yn, c.end_dt, " + 
				"				c.car_b_p2, c.r_dc_amt, c.l_dc_amt, c.r_cash_back, c.l_cash_back, c.r_card_amt, c.l_card_amt, c.r_bank_amt, c.l_bank_amt, c.etc, c.car_y_form, "+ 
				"				c.hp_yn, c.jg_tuix_st, c.lkas_yn, c.ldws_yn, c.aeb_yn, c.fcw_yn, c.etc2, c.car_y_form2, c.car_y_form3, c.duty_free_opt, "+ 
				"				c.car_y_form_yn, c.garnish_yn, c.hook_yn"+
				" FROM car_mng a, code b, car_nm c"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001' and c.car_b_dt < '"+car_b_dt+"'";

		if(!car_id.equals("") && !car_seq.equals(""))	query += " and c.car_id = '"+car_id+"' and c.car_seq = '"+car_seq+"'";
		if(!car_id.equals("") && car_seq.equals(""))	query += " and c.car_id = '"+car_id+"' and c.car_seq = (select max(car_seq) from car_nm where car_id='"+car_id+"')";

		query += " order by c.car_name";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
			    bean.setCar_comp_id		(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm		(rs.getString("CAR_COMP_NM"));
			    bean.setCode			(rs.getString("CODE"));
				bean.setCar_cd			(rs.getString("CAR_CD"));
			    bean.setCar_nm			(rs.getString("CAR_NM"));
			    bean.setCar_id			(rs.getString("CAR_ID"));
			    bean.setCar_name		(rs.getString("CAR_NAME"));
				bean.setCar_yn			(rs.getString("CAR_YN"));
				bean.setSection			(rs.getString("SECTION"));
			    bean.setCar_seq			(rs.getString("CAR_SEQ"));
				bean.setCar_b			(rs.getString("CAR_B"));
				bean.setCar_b_p			(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt		(rs.getString("CAR_B_DT"));
				bean.setDpm				(rs.getInt("DPM"));
				bean.setMax_le_36		(rs.getInt("MAX_LE_36"));
				bean.setMax_le_24		(rs.getInt("MAX_LE_24"));
				bean.setMax_le_12		(rs.getInt("MAX_LE_12"));
				bean.setMax_re_36		(rs.getInt("MAX_RE_36"));
				bean.setMax_re_24		(rs.getInt("MAX_RE_24"));
				bean.setMax_re_18		(rs.getInt("MAX_RE_18"));
				bean.setS_st			(rs.getString("S_ST"));
				bean.setEst_yn			(rs.getString("EST_YN"));
				bean.setCar_b_inc_id	(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq	(rs.getString("CAR_B_INC_SEQ"));
				bean.setSh_code			(rs.getString("SH_CODE"));
				bean.setDiesel_yn		(rs.getString("DIESEL_YN"));
				bean.setAuto_yn			(rs.getString("AUTO_YN"));
				bean.setJg_code			(rs.getString("JG_CODE"));
				bean.setAir_ds_yn		(rs.getString("air_ds_yn")==null?"":rs.getString("air_ds_yn"));
				bean.setAir_as_yn		(rs.getString("air_as_yn")==null?"":rs.getString("air_as_yn"));
				bean.setAir_cu_yn		(rs.getString("air_cu_yn")==null?"":rs.getString("air_cu_yn"));
				bean.setAbs_yn			(rs.getString("abs_yn")==null?"":rs.getString("abs_yn"));
				bean.setRob_yn			(rs.getString("rob_yn")==null?"":rs.getString("rob_yn"));
				bean.setSp_car_yn		(rs.getString("sp_car_yn")==null?"":rs.getString("sp_car_yn"));
				bean.setEnd_dt			(rs.getString("end_dt")==null?"N":rs.getString("end_dt"));
				bean.setCar_b_p2		(rs.getInt   ("car_b_p2"));
				bean.setR_dc_amt		(rs.getInt   ("r_dc_amt"));
				bean.setL_dc_amt		(rs.getInt   ("l_dc_amt"));
				bean.setR_cash_back		(rs.getInt   ("r_cash_back"));
				bean.setL_cash_back		(rs.getInt   ("l_cash_back"));
				bean.setR_card_amt		(rs.getInt   ("r_card_amt"));
				bean.setL_card_amt		(rs.getInt   ("l_card_amt"));
				bean.setR_bank_amt		(rs.getInt   ("r_bank_amt"));
				bean.setL_bank_amt		(rs.getInt   ("l_bank_amt"));
				bean.setEtc				(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setCar_y_form		(rs.getString("car_y_form")==null?"":rs.getString("car_y_form"));
				bean.setHp_yn			(rs.getString("hp_yn")==null?"":rs.getString("hp_yn"));
				bean.setJg_tuix_st		(rs.getString("jg_tuix_st")==null?"":rs.getString("jg_tuix_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setGarnish_yn		(rs.getString("garnish_yn")==null?"":rs.getString("garnish_yn"));	//가니쉬
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));	//견인고리
				bean.setEtc2			(rs.getString("etc2")==null?"":rs.getString("etc2")); 	//기타 추가(2018.02.08)
				bean.setCar_y_form2		(rs.getString("car_y_form2")==null?"":rs.getString("car_y_form2"));
				bean.setCar_y_form3		(rs.getString("car_y_form3")==null?"":rs.getString("car_y_form3"));
				bean.setDuty_free_opt	(rs.getString("duty_free_opt")==null?"":rs.getString("duty_free_opt"));	//개소세 면세가/과세가 표기(20190429)
				bean.setCar_y_form_yn	(rs.getString("car_y_form_yn")==null?"":rs.getString("car_y_form_yn"));	//신차견적서 연형표기여부(20190610)
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 System.out.println(car_id);
			 System.out.println(car_seq);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }


	/**
     * 차명 등록. 고침.
     */
    public String insertCarNm(CarMstBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String query1 = "";
        int count = 0;
		String car_id = "";

		query = " insert into car_nm ( car_comp_id,car_id,car_cd,car_name,use_yn,car_seq,car_b,car_b_p,car_b_dt,section,dpm,max_le_36,max_le_24,max_le_12,max_re_36,max_re_24,max_re_18, "+
				"                      s_st,est_yn,car_b_inc_id,car_b_inc_seq, sh_code, diesel_yn, auto_yn, jg_code, air_ds_yn, air_as_yn, air_cu_yn, abs_yn, rob_yn, sp_car_yn, end_dt, "+
				"                      car_b_p2, r_dc_amt, l_dc_amt, r_cash_back, l_cash_back, r_card_amt, l_card_amt, r_bank_amt, l_bank_amt, etc, car_y_form, hp_yn, jg_tuix_st, " +
				"                      lkas_yn, ldws_yn, aeb_yn, fcw_yn, etc2, car_y_form2, car_y_form3, duty_free_opt, car_y_form_yn ) "+
				" SELECT ?,DECODE(?,'',nvl(lpad(max(B.CAR_ID)+1,6,'0'),'000001'),?), "+
				"		 ?,?,?,MAX(A.SEQ),'"+bean.getCar_b().trim()+"',?,REPLACE(?,'-',''), "+
				"        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,REPLACE(?,'-',''),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? "+
				" FROM  "+
				" ( select nvl(lpad(max(CAR_SEQ)+1,2,'0'),'01') SEQ "+
				"     from car_nm  "+
				"    WHERE CAR_ID=? "+
				"  ) A, CAR_NM B ";

		query1 = " select max(car_id)  from car_nm ";

       try{
			con.setAutoCommit(false);
			
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id	().trim());
            pstmt.setString(2, bean.getCar_id		().trim());
			pstmt.setString(3, bean.getCar_id		().trim());
            pstmt.setString(4, bean.getCar_cd		().trim());
            pstmt.setString(5, bean.getCar_name		().trim());
            pstmt.setString(6, bean.getCar_yn		().trim());
            pstmt.setInt   (7, bean.getCar_b_p		());
            pstmt.setString(8, bean.getCar_b_dt		().trim());
            pstmt.setString(9, bean.getSection		().trim());
            pstmt.setInt   (10, bean.getDpm			());
            pstmt.setInt   (11, bean.getMax_le_36	());
            pstmt.setInt   (12, bean.getMax_le_24	());
            pstmt.setInt   (13, bean.getMax_le_12	());
            pstmt.setInt   (14, bean.getMax_re_36	());
            pstmt.setInt   (15, bean.getMax_re_24	());
            pstmt.setInt   (16, bean.getMax_re_18	());
            pstmt.setString(17, bean.getS_st		().trim());
            pstmt.setString(18, bean.getEst_yn		().trim());
			pstmt.setString(19, bean.getCar_b_inc_id());
			pstmt.setString(20, bean.getCar_b_inc_seq());
			pstmt.setString(21, bean.getSh_code		());
			pstmt.setString(22, bean.getDiesel_yn	());
			pstmt.setString(23, bean.getAuto_yn		());
			pstmt.setString(24, bean.getJg_code		());
			pstmt.setString(25, bean.getAir_ds_yn	());
			pstmt.setString(26, bean.getAir_as_yn	());
			pstmt.setString(27, bean.getAir_cu_yn	());
			pstmt.setString(28, bean.getAbs_yn 		());
			pstmt.setString(29, bean.getRob_yn		());
			pstmt.setString(30, bean.getSp_car_yn	());
			pstmt.setString(31, bean.getEnd_dt		());
			pstmt.setInt   (32, bean.getCar_b_p2	());
            pstmt.setInt   (33, bean.getR_dc_amt	());
            pstmt.setInt   (34, bean.getL_dc_amt	());
            pstmt.setInt   (35, bean.getR_cash_back	());
            pstmt.setInt   (36, bean.getL_cash_back	());
            pstmt.setInt   (37, bean.getR_card_amt	());
            pstmt.setInt   (38, bean.getL_card_amt	());
            pstmt.setInt   (39, bean.getR_bank_amt	());
            pstmt.setInt   (40, bean.getL_bank_amt	());
			pstmt.setString(41, bean.getEtc			());
			pstmt.setString(42, bean.getCar_y_form	());
			pstmt.setString(43, bean.getHp_yn		());
			pstmt.setString(44, bean.getJg_tuix_st	());
			pstmt.setString(45, bean.getLkas_yn		());
			pstmt.setString(46, bean.getLdws_yn	());
			pstmt.setString(47, bean.getAeb_yn		());
			pstmt.setString(48, bean.getFcw_yn		());
			//pstmt.setString(49, bean.getHook_yn		());
			pstmt.setString(49, bean.getEtc2		());	//기타 추가(2018.02.08)
			pstmt.setString(50, bean.getCar_y_form2	());
			pstmt.setString(51, bean.getCar_y_form3	());
			pstmt.setString(52, bean.getDuty_free_opt	());	//개소세 면세가/과세가 표기(20190429)
			pstmt.setString(53, bean.getCar_y_form_yn	());	//신차견적서 연형표기여부(20190610)
			pstmt.setString(54, bean.getCar_id		().trim());
            count = pstmt.executeUpdate();
            pstmt.close();
			
			//car_id 가져오기
			if(bean.getCar_id().equals("")){
				pstmt = con.prepareStatement(query1);
				rs = pstmt.executeQuery();
				if(rs.next()){
					car_id = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
				pstmt.close();
			}else{
				car_id = bean.getCar_id();
			}
			
			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:insertCarNm]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return car_id;
    }


    /**
     * 차명 수정.
     */
    public int updateCarNm(CarMstBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_NM "+
				" SET     CAR_NAME=?, USE_YN=?, CAR_B='"+bean.getCar_b().trim()+"', CAR_B_P=?, CAR_B_DT=replace(?,'-',''), \n"+
					    " SECTION=?, DPM=?, MAX_LE_36=?, MAX_LE_24=?, MAX_LE_12=?, MAX_RE_36=?, MAX_RE_24=?, MAX_RE_18=?, S_ST=?, EST_YN=?, CAR_B_INC_ID=?, CAR_B_INC_SEQ=?, SH_CODE=?, DIESEL_YN=?, AUTO_YN=?, JG_CODE=?,  \n"+
						" air_ds_yn		= ?,  \n"+
						" air_as_yn		= ?,  \n"+
						" air_cu_yn		= ?,  \n"+
						" abs_yn 		= ?,  \n"+
						" rob_yn		= ?, "+
						" sp_car_yn		= ?, "+
						" END_DT        = ?, \n"+
						" car_b_p2		= ?, \n "+
						" r_dc_amt		= ?, \n "+
						" l_dc_amt		= ?, \n "+
						" r_cash_back	= ?, \n "+
						" l_cash_back	= ?,  \n"+
						" r_card_amt	= ?, \n "+
						" l_card_amt	= ?,  \n"+
						" r_bank_amt	= ?,  \n"+
						" l_bank_amt	= ?, \n "+
						" etc	        = ?,  \n"+
						" car_y_form    = ?, hp_yn=?, jg_tuix_st=?, lkas_yn=?, ldws_yn=?, aeb_yn=?, fcw_yn=?, \n"+		
						" etc2	        = ?, car_y_form2    = ?, car_y_form3    = ?,  \n"+	//기타 추가(2018.02.08)
						" duty_free_opt = ?,	\n"+	//개소세 면세가/과세가 표기(20190429)
						" car_y_form_yn = ?	\n"+	//신차견적서 연형표기여부(20190610)
				" WHERE CAR_ID=? AND CAR_COMP_ID=? AND CAR_CD=? AND CAR_SEQ=?\n";
           
       try{

            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getCar_name		().trim());
            pstmt.setString(2, bean.getCar_yn		().trim());
			pstmt.setInt   (3, bean.getCar_b_p		());
			pstmt.setString(4, bean.getCar_b_dt		().trim());
            pstmt.setString(5, bean.getSection		().trim());
            pstmt.setInt   (6, bean.getDpm			());
            pstmt.setInt   (7, bean.getMax_le_36	());
            pstmt.setInt   (8, bean.getMax_le_24	());
            pstmt.setInt   (9, bean.getMax_le_12	());
            pstmt.setInt   (10, bean.getMax_re_36	());
            pstmt.setInt   (11, bean.getMax_re_24	());
            pstmt.setInt   (12, bean.getMax_re_18	());
            pstmt.setString(13, bean.getS_st		().trim());
            pstmt.setString(14, bean.getEst_yn		().trim());
			pstmt.setString(15, bean.getCar_b_inc_id());
			pstmt.setString(16, bean.getCar_b_inc_seq());
			pstmt.setString(17, bean.getSh_code		().trim());
			pstmt.setString(18, bean.getDiesel_yn	().trim());
			pstmt.setString(19, bean.getAuto_yn		().trim());
			pstmt.setString(20, bean.getJg_code		().trim());
			pstmt.setString(21, bean.getAir_ds_yn	());
			pstmt.setString(22, bean.getAir_as_yn	());
			pstmt.setString(23, bean.getAir_cu_yn	());
			pstmt.setString(24, bean.getAbs_yn 		());
			pstmt.setString(25, bean.getRob_yn		());
			pstmt.setString(26, bean.getSp_car_yn	());
			pstmt.setString(27, bean.getEnd_dt		());
			pstmt.setInt   (28, bean.getCar_b_p2	());
            pstmt.setInt   (29, bean.getR_dc_amt	());
            pstmt.setInt   (30, bean.getL_dc_amt	());
            pstmt.setInt   (31, bean.getR_cash_back	());
            pstmt.setInt   (32, bean.getL_cash_back	());
            pstmt.setInt   (33, bean.getR_card_amt	());
            pstmt.setInt   (34, bean.getL_card_amt	());
            pstmt.setInt   (35, bean.getR_bank_amt	());
            pstmt.setInt   (36, bean.getL_bank_amt	());
			pstmt.setString(37, bean.getEtc			());
			pstmt.setString(38, bean.getCar_y_form	());
			pstmt.setString(39, bean.getHp_yn		());
			pstmt.setString(40, bean.getJg_tuix_st	());
			pstmt.setString(41, bean.getLkas_yn 	());
			pstmt.setString(42, bean.getLdws_yn		());
			pstmt.setString(43, bean.getAeb_yn  	());
			pstmt.setString(44, bean.getFcw_yn 		());
			//pstmt.setString(45, bean.getHook_yn 	());
			pstmt.setString(45, bean.getEtc2		());	//기타 추가(2018.02.08)
			pstmt.setString(46, bean.getCar_y_form2	());
			pstmt.setString(47, bean.getCar_y_form3	());
			pstmt.setString(48, bean.getDuty_free_opt ());	//개소세 면세가/과세가 표기(20190429)
			pstmt.setString(49, bean.getCar_y_form_yn ());	//신차견적서 연형표기여부(20190610)
            pstmt.setString(50, bean.getCar_id		().trim());
            pstmt.setString(51, bean.getCar_comp_id	().trim());
            pstmt.setString(52, bean.getCar_cd		().trim());
            pstmt.setString(53, bean.getCar_seq		().trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarNm]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }


	//선택사양-------------------------------------------------------------------------------------------------------------------

	/**
     * 차종별 선택사양 조회.
     */
    public CarSelBean [] getCarSelList(String car_comp_id, String car_cd, String car_seq, String view_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";

		if(car_seq.equals("")) car_seq = "01";
        
        query = " SELECT * FROM car_sel"+
				" where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_u_seq='"+car_seq+"'";

		

		if(view_dt.equals("")){//최신날짜
			query += " and car_s_dt = (select max(car_s_dt) car_s_dt from car_sel where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_u_seq='"+car_seq+"')";
		}else{//기준일자 조회
			if(!view_dt.equals("0")) query += " and car_s_dt = '"+view_dt+"'";
		}



        Collection<CarSelBean> col = new ArrayList<CarSelBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarSelBean bean = new CarSelBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_u_seq(rs.getString("CAR_U_SEQ"));
			    bean.setCar_s_seq(rs.getString("CAR_S_SEQ"));
				bean.setUse_yn(rs.getString("USE_YN"));
			    bean.setCar_s(rs.getString("CAR_S"));
			    bean.setCar_s_p(rs.getInt("CAR_S_P"));
			    bean.setCar_s_dt(rs.getString("CAR_S_DT"));
				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarSelBean[])col.toArray(new CarSelBean[0]);
    }

	/**
     * 차종별 선택사양 조회.
     */
    public CarOptBean [] getCarOptList(String car_comp_id, String car_cd, String car_id, String car_seq, String view_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";

        query = " SELECT * FROM car_opt"+
				" where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_id='"+car_id+"'";
		
		if(!car_seq.equals("")){
			query += " and car_u_seq='"+car_seq+"'";
		}else{
			//최신날짜
			if(view_dt.equals("")){
				query += " and car_s_dt = (select max(car_s_dt) car_s_dt from car_opt where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_id='"+car_id+"'";
				if(!car_seq.equals(""))	query += " and car_u_seq='"+car_seq+"')";
				else					query += " )";
			//기준일자 조회
			}else{
				if(!view_dt.equals("0")) query += " and car_s_dt = '"+view_dt+"'";
			}
		}
		
		query += " ORDER BY TO_NUMBER(car_rank) asc";

        Collection<CarOptBean> col = new ArrayList<CarOptBean>();

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarOptBean bean = new CarOptBean();
			    bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
				bean.setCar_cd		(rs.getString("CAR_CD"));
				bean.setCar_id		(rs.getString("CAR_ID"));
			    bean.setCar_u_seq	(rs.getString("CAR_U_SEQ"));
			    bean.setCar_s_seq	(rs.getString("CAR_S_SEQ"));
				bean.setUse_yn		(rs.getString("USE_YN"));
			    bean.setCar_s		(rs.getString("CAR_S"));
			    bean.setCar_s_p		(rs.getInt("CAR_S_P"));
			    bean.setCar_s_dt	(rs.getString("CAR_S_DT"));
				bean.setOpt_b		(rs.getString("OPT_B"));
				bean.setJg_opt_st	(rs.getString("JG_OPT_ST"));
				bean.setJg_tuix_st	(rs.getString("JG_TUIX_ST"));
				bean.setLkas_yn		(rs.getString("LKAS_YN"));
				bean.setLdws_yn		(rs.getString("LDWS_YN"));
				bean.setAeb_yn		(rs.getString("AEB_YN"));
				bean.setFcw_yn		(rs.getString("FCW_YN"));				
				bean.setJg_opt_yn	(rs.getString("JG_OPT_YN"));
				bean.setGarnish_yn	(rs.getString("GARNISH_YN"));
				bean.setHook_yn		(rs.getString("HOOK_YN"));
				bean.setCar_rank	(rs.getString("CAR_RANK"));
				col.add(bean); 
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarOptBean[])col.toArray(new CarOptBean[0]);
    }

	/**
     * 차종별 선택사양 조회.
     */
    public CarOptBean getCarOptCase(String car_comp_id, String car_cd, String car_id, String car_seq, String car_s_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        CarOptBean bean = new CarOptBean();

        query = " SELECT * FROM car_opt"+
				" where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_id='"+car_id+"' and car_u_seq='"+car_seq+"' and car_s_seq='"+car_s_seq+"'";
		
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){	            
			    bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
				bean.setCar_cd		(rs.getString("CAR_CD"));
				bean.setCar_id		(rs.getString("CAR_ID"));
			    bean.setCar_u_seq	(rs.getString("CAR_U_SEQ"));
			    bean.setCar_s_seq	(rs.getString("CAR_S_SEQ"));
				bean.setUse_yn		(rs.getString("USE_YN"));
			    bean.setCar_s		(rs.getString("CAR_S"));
			    bean.setCar_s_p		(rs.getInt   ("CAR_S_P"));
			    bean.setCar_s_dt	(rs.getString("CAR_S_DT"));
				bean.setJg_opt_st	(rs.getString("JG_OPT_ST"));
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }



	/**
     * 선택사양 등록.
     */
    public int insertCarSel(CarSelBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " INSERT INTO CAR_SEL"+
				" ( CAR_COMP_ID, CAR_CD, CAR_U_SEQ, CAR_S_SEQ, USE_YN, CAR_S, CAR_S_P, CAR_S_DT )\n"
				+ "SELECT ?, ?, ?, nvl(lpad(max(CAR_S_SEQ)+1,2,'0'),'01'), ?, ?, ?, replace(?,'-','')\n"
				+ "FROM CAR_SEL where car_comp_id=? and car_cd=? and car_u_seq=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id().trim());
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_u_seq().trim());
            pstmt.setString(4, bean.getUse_yn().trim());
            pstmt.setString(5, bean.getCar_s().trim());
            pstmt.setInt   (6, bean.getCar_s_p());
            pstmt.setString(7, bean.getCar_s_dt().trim());
            pstmt.setString(8, bean.getCar_comp_id().trim());
            pstmt.setString(9, bean.getCar_cd().trim());
            pstmt.setString(10, bean.getCar_u_seq().trim());
            count = pstmt.executeUpdate();
       
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:insertCarSel]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 선택사양 등록.
     */
    public int insertCarOpt(CarOptBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " INSERT INTO CAR_OPT"+
				" ( CAR_COMP_ID, CAR_CD, CAR_ID, CAR_U_SEQ, CAR_S_SEQ, USE_YN, CAR_S, CAR_S_P, CAR_S_DT, OPT_B, JG_OPT_ST, JG_TUIX_ST, LKAS_YN, LDWS_YN, AEB_YN, FCW_YN, GARNISH_YN, HOOK_YN, CAR_RANK, JG_OPT_YN ) \n"
				+ "SELECT ?, ?, ?, ?, nvl(lpad(max(CAR_S_SEQ)+1,2,'0'),'01'), ?, ?, ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? \n"
				+ "FROM CAR_OPT where car_comp_id=? and car_cd=? and car_id=? and car_u_seq=?\n";
           
       try{
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(query);
            pstmt.setString(1,  bean.getCar_comp_id().trim());
            pstmt.setString(2,  bean.getCar_cd().trim()		);
            pstmt.setString(3,  bean.getCar_id().trim()		);
            pstmt.setString(4,  bean.getCar_u_seq().trim()	);
            pstmt.setString(5,  bean.getUse_yn().trim()		);
            pstmt.setString(6,  bean.getCar_s().trim()		);
            pstmt.setInt   (7,  bean.getCar_s_p()			);
            pstmt.setString(8,  bean.getCar_s_dt().trim()	);
			pstmt.setString(9,  bean.getOpt_b().trim()	    );
			pstmt.setString(10, bean.getJg_opt_st().trim() );
			pstmt.setString(11, bean.getJg_tuix_st().trim() );
			pstmt.setString(12, bean.getLkas_yn().trim()    );
			pstmt.setString(13, bean.getLdws_yn().trim()   );
			pstmt.setString(14, bean.getAeb_yn().trim()     );
			pstmt.setString(15, bean.getFcw_yn().trim()     );
			pstmt.setString(16, bean.getGarnish_yn().trim()     );
			pstmt.setString(17, bean.getHook_yn().trim()     );
			pstmt.setString(18, bean.getCar_rank().trim()     );
			pstmt.setString(19, bean.getJg_opt_yn().trim()     );
            pstmt.setString(20, bean.getCar_comp_id().trim());
            pstmt.setString(21, bean.getCar_cd().trim()		);
            pstmt.setString(22, bean.getCar_id().trim()		);
            pstmt.setString(23, bean.getCar_u_seq().trim()	);
            count = pstmt.executeUpdate();
            
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:insertCarOpt]"+se);

				System.out.println("[bean.getCar_comp_id().trim()	]"+bean.getCar_comp_id().trim()	);
				System.out.println("[bean.getCar_cd().trim()		]"+bean.getCar_cd().trim()		);
				System.out.println("[bean.getCar_id().trim()		]"+bean.getCar_id().trim()		);
				System.out.println("[bean.getCar_u_seq().trim()		]"+bean.getCar_u_seq().trim()	);
				System.out.println("[bean.getUse_yn().trim()		]"+bean.getUse_yn().trim()		);
				System.out.println("[bean.getCar_s().trim()			]"+bean.getCar_s().trim()		);
				System.out.println("[bean.getCar_s_p()				]"+bean.getCar_s_p()			);
				System.out.println("[bean.getCar_s_dt().trim()		]"+bean.getCar_s_dt().trim()	);
				System.out.println("[bean.getCar_comp_id().trim()	]"+bean.getCar_comp_id().trim()	);
				System.out.println("[bean.getCar_cd().trim()		]"+bean.getCar_cd().trim()		);
				System.out.println("[bean.getCar_id().trim()		]"+bean.getCar_id().trim()		);
				System.out.println("[bean.getCar_u_seq().trim()		]"+bean.getCar_u_seq().trim()	);
				System.out.println("[bean.getJg_opt_st().trim()		]"+bean.getJg_opt_st().trim() );
				System.out.println("[bean.getLkas_yn().trim()			]"+bean.getLkas_yn().trim()    );
				System.out.println("[bean.getLdws_yn().trim()			]"+bean.getLdws_yn().trim()   );
				System.out.println("[bean.getAeb_yn().trim()			]"+bean.getAeb_yn().trim()     );
				System.out.println("[bean.getGarnish_yn().trim()	]"+bean.getGarnish_yn().trim()		);
				System.out.println("[bean.getHook_yn().trim()	]"+bean.getHook_yn().trim()		);
				System.out.println("[bean.getFcw_yn().trim()			]"+bean.getFcw_yn().trim()+"/");

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
     * 선택사양 순서정렬 저장.
     */
    public int updateCarOptOderby(CarOptBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_OPT SET \n"+
				" car_rank=? \n"+
				" WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_ID=? AND CAR_U_SEQ=? AND CAR_S_SEQ=? \n";

       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, bean.getCar_rank().trim());
            pstmt.setString(2, bean.getCar_comp_id().trim());
            pstmt.setString(3, bean.getCar_cd().trim());
            pstmt.setString(4, bean.getCar_id().trim());
            pstmt.setString(5,bean.getCar_u_seq().trim());
            pstmt.setString(6,bean.getCar_s_seq().trim());
            count = pstmt.executeUpdate();             

		    pstmt.close();
            con.commit();
            // System.out.println("[AddCarMstDatabase:updateCarOptOderby]"+query);
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarOptOderby]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 선택사양 수정.
     */
    public int updateCarSel(CarSelBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_SEL SET"+
				" USE_YN=?, CAR_S=?, CAR_S_P=?, CAR_S_DT=replace(?,'-','')"+
				" WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_U_SEQ=? AND CAR_S_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getUse_yn().trim());
			pstmt.setString(2, bean.getCar_s().trim());
			pstmt.setInt   (3, bean.getCar_s_p());
			pstmt.setString(4, bean.getCar_s_dt().trim());
            pstmt.setString(5, bean.getCar_comp_id().trim());
            pstmt.setString(6, bean.getCar_cd().trim());
            pstmt.setString(7, bean.getCar_u_seq().trim());
            pstmt.setString(8, bean.getCar_s_seq().trim());
            count = pstmt.executeUpdate();             

	        pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarSel]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 선택사양 수정.
     */
    public int updateCarOpt(CarOptBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_OPT SET \n"+
				" USE_YN=?, CAR_S=?, CAR_S_P=?, CAR_S_DT=replace(?,'-',''), OPT_B=?, jg_opt_st=?, jg_tuix_st=?, lkas_yn=?, ldws_yn=?, aeb_yn=?, fcw_yn=?, garnish_yn=?, hook_yn=?, car_rank=?, jg_opt_yn=? \n"+
				" WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_ID=? AND CAR_U_SEQ=? AND CAR_S_SEQ=? \n";

       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getUse_yn().trim());
			pstmt.setString(2, bean.getCar_s().trim());
			pstmt.setInt   (3, bean.getCar_s_p());
			pstmt.setString(4, bean.getCar_s_dt().trim());
			pstmt.setString(5, bean.getOpt_b().trim());
			pstmt.setString(6, bean.getJg_opt_st().trim());
			pstmt.setString(7, bean.getJg_tuix_st().trim());
			pstmt.setString(8, bean.getLkas_yn().trim());
			pstmt.setString(9, bean.getLdws_yn().trim());
			pstmt.setString(10, bean.getAeb_yn().trim());
			pstmt.setString(11, bean.getFcw_yn().trim());
			pstmt.setString(12, bean.getGarnish_yn().trim());
			pstmt.setString(13, bean.getHook_yn().trim());
			pstmt.setString(14, bean.getCar_rank().trim());
			pstmt.setString(15, bean.getJg_opt_yn().trim());
            pstmt.setString(16, bean.getCar_comp_id().trim());
            pstmt.setString(17, bean.getCar_cd().trim());
            pstmt.setString(18, bean.getCar_id().trim());
            pstmt.setString(19,bean.getCar_u_seq().trim());
            pstmt.setString(20,bean.getCar_s_seq().trim());
            count = pstmt.executeUpdate();             

		    pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarOpt]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }


    /**
     * 선택사양 삭제.
     */
    public int deleteCarSel(CarSelBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM CAR_SEL WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_U_SEQ=? AND CAR_S_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id().trim());			
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_u_seq().trim());
            pstmt.setString(4, bean.getCar_s_seq().trim());
            count = pstmt.executeUpdate();  
            
            pstmt.close();           
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarSel]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 선택사양 삭제.
     */
    public int deleteCarOpt(CarOptBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM CAR_OPT WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_ID=? AND CAR_U_SEQ=? AND CAR_S_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id().trim());			
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_id().trim());
            pstmt.setString(4, bean.getCar_u_seq().trim());
            pstmt.setString(5, bean.getCar_s_seq().trim());
            count = pstmt.executeUpdate();      
            
            pstmt.close();       
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarOpt]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 선택사양 삭제.
     */
    public int deleteCarOpt(String car_comp_id, String car_cd, String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM CAR_OPT WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_ID=? AND CAR_U_SEQ=? \n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_comp_id);			
            pstmt.setString(2, car_cd);
            pstmt.setString(3, car_id);
            pstmt.setString(4, car_seq);
            count = pstmt.executeUpdate();      
            
            pstmt.close();       
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarOpt]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }


	//색상-------------------------------------------------------------------------------------------------------------------

	/**
     * 차종별 색상 조회.
     */
    public CarColBean [] getCarColList(String car_comp_id, String car_cd, String car_seq, String view_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";

		if(car_seq.equals("")) car_seq = "01";
        
        query = " SELECT * "+
				" FROM   car_col "+
				" where  car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"'";
	
		if(view_dt.equals("")){//사용중
										query += " and use_yn='Y' ";
		}else if(view_dt.equals("99999999")){//최신날짜
										query += " and car_u_seq='"+car_seq+"' and car_c_dt = (select max(car_c_dt) car_s_dt from car_col where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_u_seq='"+car_seq+"')";
		}else{//기준일자 조회
			if(!view_dt.equals("0"))	query += " and car_u_seq='"+car_seq+"' and car_c_dt = '"+view_dt+"'";
		}

		query += " ORDER BY car_comp_id, car_cd, car_u_seq, NVL(col_st,'1'), to_number(car_c_seq) ";

//System.out.println("col : "+query);
        Collection<CarColBean> col = new ArrayList<CarColBean>();

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarColBean bean = new CarColBean();
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_u_seq	(rs.getString("CAR_U_SEQ"));
			    bean.setCar_c_seq	(rs.getString("CAR_C_SEQ"));
				bean.setUse_yn		(rs.getString("USE_YN"));
			    bean.setCar_c		(rs.getString("CAR_C"));
			    bean.setCar_c_p		(rs.getInt   ("CAR_C_P"));
			    bean.setCar_c_dt	(rs.getString("CAR_C_DT"));
				bean.setEtc			(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setCol_st		(rs.getString("col_st")==null?"":rs.getString("col_st"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				col.add(bean); 
            }
            
            rs.close();
            stmt.close();


        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCarColList]"+se);
			System.out.println("[AddCarMstDatabase:getCarColList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarColBean[])col.toArray(new CarColBean[0]);
    }
    
    /**
     * 차종별 색상 조회-수정
     * date : 2017. 01. 16
     * author : 성승현
     */
    public CarColBean [] getCarColListTrim(String car_comp_id, String car_cd, String col_st, String use_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";

        
        query = " SELECT * "+
				" FROM   car_col "+
				" where  car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"'";
	
		if(use_yn.equals("N")){//사용중
			query += " and use_yn='N' ";
		}else{
			query += " and use_yn='Y' ";
		}

		if(col_st.equals("1") || col_st.equals("2") || col_st.equals("3")){//내외장 모두
			query += " and col_st='"+col_st+"' ";
		}else{
			query += " and col_st IN ('1', '2', '3') ";			
		}
		
		query += " ORDER BY car_comp_id, car_cd, NVL(col_st,'1'), car_c_dt, to_number(car_c_seq) ";

//System.out.println("col : "+query);
        Collection<CarColBean> col = new ArrayList<CarColBean>();

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarColBean bean = new CarColBean();
			    bean.setCar_comp_id		(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_u_seq	(rs.getString("CAR_U_SEQ"));
			    bean.setCar_c_seq	(rs.getString("CAR_C_SEQ"));
				bean.setUse_yn		(rs.getString("USE_YN"));
			    bean.setCar_c		(rs.getString("CAR_C"));
			    bean.setCar_c_p		(rs.getInt   ("CAR_C_P"));
			    bean.setCar_c_dt	(rs.getString("CAR_C_DT"));
				bean.setEtc			(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setCol_st		(rs.getString("col_st")==null?"":rs.getString("col_st"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				col.add(bean); 
            }
            
            rs.close();
            stmt.close();


        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCarColList]"+se);
			System.out.println("[AddCarMstDatabase:getCarColList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarColBean[])col.toArray(new CarColBean[0]);
    }
    
    /**
     * 트림별 색상 조회
     * date : 2017. 01. 23
     * author : 성승현
     */
    public CarTrimBean [] getCarTrimCol(String car_comp_id, String car_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";

        
        query = " SELECT * \n"+
				" FROM   car_col_trim \n"+
				" where  car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' \n";
	
		
		query += " ORDER BY car_comp_id, car_cd ";

//System.out.println("col : "+query);
        Collection<CarTrimBean> col = new ArrayList<CarTrimBean>();

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarTrimBean bean = new CarTrimBean();
			    bean.setCar_comp_id		(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_id		(rs.getString("car_id")==null?"":rs.getString("car_id"));
			    bean.setCar_u_seq	(rs.getString("CAR_U_SEQ")==null?"":rs.getString("CAR_U_SEQ"));
			    bean.setCar_c_seq	(rs.getString("CAR_C_SEQ")==null?"":rs.getString("CAR_C_SEQ"));
				col.add(bean); 
            }
            
            rs.close();
            stmt.close();


        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCarTrimCol]"+se);
			System.out.println("[AddCarMstDatabase:getCarTrimCol]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarTrimBean[])col.toArray(new CarTrimBean[0]);
    }

	/**
     * 색상 등록.
     */
    public int insertCarCol(CarColBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " INSERT INTO CAR_COL"+
				" ( CAR_COMP_ID, CAR_CD, CAR_U_SEQ, CAR_C_SEQ, USE_YN, CAR_C, CAR_C_P, CAR_C_DT, ETC, COL_ST, jg_opt_st )\n"
				+ "SELECT ?, ?, ?, nvl(TO_CHAR(max(TO_NUMBER(CAR_C_SEQ))+1),'1'), ?, ?, ?, replace(?,'-',''), ?, ?, ? \n"
				+ "FROM CAR_COL where car_comp_id=? and car_cd=? and car_u_seq=?\n";

	   try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1,  bean.getCar_comp_id().trim());
            pstmt.setString(2,  bean.getCar_cd().trim());
            pstmt.setString(3,  bean.getCar_u_seq().trim());
            pstmt.setString(4,  bean.getUse_yn().trim());
            pstmt.setString(5,  bean.getCar_c().trim());
            pstmt.setInt   (6,  bean.getCar_c_p());
            pstmt.setString(7,  bean.getCar_c_dt().trim());
            pstmt.setString(8,  bean.getEtc().trim());
            pstmt.setString(9,  bean.getCol_st().trim());
            pstmt.setString(10, bean.getJg_opt_st().trim());
            pstmt.setString(11, bean.getCar_comp_id().trim());
			pstmt.setString(12, bean.getCar_cd().trim());
            pstmt.setString(13, bean.getCar_u_seq().trim());
            count = pstmt.executeUpdate();
             
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:insertCarCol]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
     * 색상 등록-기준일자 삭제
     * date : 2017.01.18
     * author : 성승현
     */
    public int insertCarColTrim(CarColBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " INSERT INTO CAR_COL"+
				" ( CAR_COMP_ID, CAR_CD, CAR_U_SEQ, CAR_C_SEQ, USE_YN, CAR_C, CAR_C_P, CAR_C_DT, ETC, COL_ST, jg_opt_st )\n"
				+ "SELECT ?, ?, lpad(nvl(TO_CHAR(max(TO_NUMBER(CAR_U_SEQ))),'01'),2,'0'), nvl(TO_CHAR(max(TO_NUMBER(CAR_C_SEQ))+1),'1'), ?, ?, ?, replace(?,'-',''), ?, ?, ? \n"
				+ "FROM CAR_COL where car_comp_id=? and car_cd=? \n";

	   try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1,  bean.getCar_comp_id().trim());
            pstmt.setString(2,  bean.getCar_cd().trim());
            pstmt.setString(3,  bean.getUse_yn().trim());
            pstmt.setString(4,  bean.getCar_c().trim());
            pstmt.setInt   (5,  bean.getCar_c_p());
            pstmt.setString(6,  bean.getCar_c_dt().trim());
            pstmt.setString(7,  bean.getEtc().trim());
            pstmt.setString(8,  bean.getCol_st().trim());
            pstmt.setString(9, bean.getJg_opt_st().trim());
            pstmt.setString(10, bean.getCar_comp_id().trim());
			pstmt.setString(11, bean.getCar_cd().trim());
            count = pstmt.executeUpdate();
             
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:insertCarCol]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 색상 수정.
     */
    public int updateCarCol(CarColBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_COL SET"+
				" USE_YN=?, CAR_C=?, CAR_C_P=?, CAR_C_DT=replace(?,'-',''), etc=?, col_st=?, jg_opt_st=? "+
				" WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_U_SEQ=? AND CAR_C_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getUse_yn().trim());
			pstmt.setString(2, bean.getCar_c().trim());
			pstmt.setInt   (3, bean.getCar_c_p());
			pstmt.setString(4, bean.getCar_c_dt().trim());
			pstmt.setString(5, bean.getEtc().trim());
			pstmt.setString(6, bean.getCol_st().trim());
			pstmt.setString(7, bean.getJg_opt_st().trim());
            pstmt.setString(8, bean.getCar_comp_id().trim());
            pstmt.setString(9, bean.getCar_cd().trim());
            pstmt.setString(10,bean.getCar_u_seq().trim());
            pstmt.setString(11,bean.getCar_c_seq().trim());
            count = pstmt.executeUpdate();                   
            pstmt.close();      
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarCol]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
     * 색상 수정-기준일자 삭제
     * date : 2017.01.17
     * author : 성승현
     */
    public int updateCarColTrim(CarColBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_COL SET"+
				" USE_YN=?, CAR_C=?, CAR_C_P=?, CAR_C_DT=replace(?,'-',''), etc=?, col_st=?, jg_opt_st=? "+
				" WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_U_SEQ=? AND CAR_C_SEQ=?\n";
        
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getUse_yn().trim());
			pstmt.setString(2, bean.getCar_c().trim());
			pstmt.setInt   (3, bean.getCar_c_p());
			pstmt.setString(4, bean.getCar_c_dt().trim());
			pstmt.setString(5, bean.getEtc().trim());
			pstmt.setString(6, bean.getCol_st().trim());
			pstmt.setString(7, bean.getJg_opt_st().trim());
            pstmt.setString(8, bean.getCar_comp_id().trim());
            pstmt.setString(9, bean.getCar_cd().trim());
            pstmt.setString(10,bean.getCar_u_seq().trim());
            pstmt.setString(11,bean.getCar_c_seq().trim());
            count = pstmt.executeUpdate();                   
            pstmt.close();      
            con.commit();
          
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarCol]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
     * 트림별 색상 변경
     * date : 2017.01.23
     * author : 성승현
     */
    public int insertTrimCol(CarTrimBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query =  "	INSERT INTO CAR_COL_TRIM ( CAR_COMP_ID, CAR_CD, CAR_ID, CAR_U_SEQ, CAR_C_SEQ )\n"+
        			"	VALUES( ?, ?, ?, ?, ?)  \n";
        
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);   
            pstmt.setString(1, bean.getCar_comp_id().trim());
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_id().trim());
            pstmt.setString(4,bean.getCar_u_seq().trim());
            pstmt.setString(5,bean.getCar_c_seq().trim());
            count = pstmt.executeUpdate();                   
            pstmt.close();      
            con.commit();
          
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:insertTrimCol]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
     * 트림별 색상 삭제
     * date : 2017.01.23
     * author : 성승현
     */
    public int deleteTrimCol(CarTrimBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query =  "DELETE FROM CAR_COL_TRIM WHERE CAR_COMP_ID=? AND CAR_CD=?";        
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);   
            pstmt.setString(1, bean.getCar_comp_id().trim());
            pstmt.setString(2, bean.getCar_cd().trim());
            count = pstmt.executeUpdate();                   
            pstmt.close();      
            con.commit();
          
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteTrimCol]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 색상 삭제-기준일자 삭제
     * date : 2017.01.18
     * author : 성승현
     */
    public int deleteCarColTrim(CarColBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM CAR_COL WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_C_SEQ=? AND CAR_U_SEQ=? \n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);     
            pstmt.setString(1, bean.getCar_comp_id().trim());						
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_c_seq().trim());
            pstmt.setString(4, bean.getCar_u_seq().trim());
            count = pstmt.executeUpdate();     
            
            pstmt.close();        
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarCol]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 색상 삭제.
     */
    public int deleteCarCol(CarColBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM CAR_COL WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_U_SEQ=? AND CAR_C_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);     
            pstmt.setString(1, bean.getCar_comp_id().trim());						
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_u_seq().trim());
            pstmt.setString(4, bean.getCar_c_seq().trim());
            count = pstmt.executeUpdate();     
            
            pstmt.close();        
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarCol]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	//제조사DC-------------------------------------------------------------------------------------------------------------------

	/**
     * 차종별 제조사DC 조회.
     */
    public CarDcBean [] getCarDcList(String car_comp_id, String car_cd, String car_seq, String view_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";

        query = " SELECT * FROM car_dc"+
				" where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_b_dt='"+view_dt+"' order by car_d_dt desc, car_d_seq ";
	

        Collection<CarDcBean> col = new ArrayList<CarDcBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarDcBean bean = new CarDcBean();
			    bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_u_seq	(rs.getString("CAR_B_DT"));
				bean.setCar_d_seq	(rs.getString("CAR_D_SEQ"));
			    bean.setCar_d_dt	(rs.getString("CAR_D_DT"));
			    bean.setCar_d_p		(rs.getInt   ("CAR_D_P"));
			    bean.setCar_d_per	(rs.getFloat ("CAR_D_PER"));
			    bean.setCar_d_p2	(rs.getInt   ("CAR_D_P2"));
			    bean.setCar_d_per2	(rs.getFloat ("CAR_D_PER2"));
				bean.setLs_yn		(rs.getString("LS_YN"));
				bean.setCar_d		(rs.getString("CAR_D"));
				bean.setCar_d_per_b	(rs.getString("CAR_D_PER_B"));
				bean.setCar_d_per_b2(rs.getString("CAR_D_PER_B2"));
				bean.setCar_d_dt2	(rs.getString("CAR_D_DT2"));
				bean.setCar_d_etc	(rs.getString("CAR_D_ETC"));	//제조사DC 비고 추가(2018.01.22)
				bean.setEsti_d_etc	(rs.getString("ESTI_D_ETC"));	//제조사DC 견적서 문구 추가(2020.05.07)
				bean.setHp_flag     (rs.getString("HP_FLAG"));
				col.add(bean); 
            }            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 System.out.println("[AddCarMstDatabase:getCarDcList]"+se);
	  		 System.out.println("[AddCarMstDatabase:getCarDcList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarDcBean[])col.toArray(new CarDcBean[0]);
    }

	/**
     * 차종별 제조사DC 조회.
     */
    public CarDcBean [] getCarDcDtList(String car_d_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;        
        String query = "";

        query = " SELECT c.nm car_comp_nm, b.car_nm, a.* "+
				" FROM   car_dc a, car_mng b, (select * from code where c_st='0001' and code<>'0000') c "+
				" where  a.car_d_dt=replace('"+car_d_dt+"','-','') and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_comp_id=c.code "+
				" order by a.car_comp_id, a.car_cd ";
	

        Collection<CarDcBean> col = new ArrayList<CarDcBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarDcBean bean = new CarDcBean();
			    bean.setCar_comp_nm	(rs.getString("CAR_COMP_NM"));
			    bean.setCar_nm		(rs.getString("CAR_NM"));
				bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_u_seq	(rs.getString("CAR_B_DT"));
				bean.setCar_d_seq	(rs.getString("CAR_D_SEQ"));
			    bean.setCar_d_dt	(rs.getString("CAR_D_DT"));
			    bean.setCar_d_p		(rs.getInt   ("CAR_D_P"));
			    bean.setCar_d_per	(rs.getFloat ("CAR_D_PER"));
			    bean.setCar_d_p2	(rs.getInt   ("CAR_D_P2"));
			    bean.setCar_d_per2	(rs.getFloat ("CAR_D_PER2"));
				bean.setLs_yn		(rs.getString("LS_YN"));
				bean.setCar_d		(rs.getString("CAR_D"));
				bean.setCar_d_per_b	(rs.getString("CAR_D_PER_B"));
				bean.setCar_d_per_b2(rs.getString("CAR_D_PER_B2"));
				bean.setCar_d_dt2	(rs.getString("CAR_D_DT2"));
				col.add(bean); 
            }            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCarDcDtList]"+se);
			System.out.println("[AddCarMstDatabase:getCarDcDtList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarDcBean[])col.toArray(new CarDcBean[0]);
    }
	/**
     * 차종별 제조사DC 조회.
     */
    public CarDcBean [] getCarDcMaxUpdList() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";

        query = " SELECT a.* \n"+
				" FROM CAR_DC a, (SELECT car_comp_id, car_cd, max(car_b_dt) car_b_dt, max(car_d_dt) car_d_dt, max(car_d_seq) car_d_seq FROM CAR_DC WHERE car_d_dt > TO_CHAR(SYSDATE-35,'YYYYMMDD') GROUP BY car_comp_id, car_cd) b \n"+
				" WHERE a.car_comp_id=b.car_comp_id AND a.car_cd=b.car_cd AND a.car_b_dt=b.car_b_dt AND a.car_d_dt=b.car_d_dt AND a.car_d_seq=b.car_d_seq \n"+
				" ORDER BY a.car_comp_id, a.car_cd, a.car_b_dt, a.car_d_dt ";
	
        Collection<CarDcBean> col = new ArrayList<CarDcBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarDcBean bean = new CarDcBean();
			    bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_u_seq	(rs.getString("CAR_B_DT"));
				bean.setCar_d_seq	(rs.getString("CAR_D_SEQ"));
			    bean.setCar_d_dt	(rs.getString("CAR_D_DT"));
			    bean.setCar_d_p		(rs.getInt   ("CAR_D_P"));
			    bean.setCar_d_per	(rs.getFloat ("CAR_D_PER"));
			    bean.setCar_d_p2	(rs.getInt   ("CAR_D_P2"));
			    bean.setCar_d_per2	(rs.getFloat ("CAR_D_PER2"));
				bean.setLs_yn		(rs.getString("LS_YN"));
				bean.setCar_d		(rs.getString("CAR_D"));
				bean.setCar_d_per_b	(rs.getString("CAR_D_PER_B"));
				bean.setCar_d_per_b2(rs.getString("CAR_D_PER_B2"));
				bean.setCar_d_dt2	(rs.getString("CAR_D_DT2"));
				col.add(bean); 
            }            
            rs.close();
            stmt.close();

        }catch(SQLException se){
			 System.out.println("[AddCarMstDatabase:getCarDcMaxUpdList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarDcBean[])col.toArray(new CarDcBean[0]);
    }

	/**
     * 차종별 선택사양 조회.
     */
    public CarDcBean getCarDcNewCase(String car_comp_id, String car_cd, String view_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        CarDcBean bean = new CarDcBean();

        query = " SELECT * FROM car_dc "+
				" where  car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_b_dt='"+view_dt+"' "+	
		        " and    (car_d_dt, car_d_seq) = (select max(car_d_dt) car_d_dt, max(car_d_seq) car_d_seq from car_dc where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_b_dt='"+view_dt+"')"+
				" ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){	            
			    bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_u_seq	(rs.getString("CAR_B_DT"));
				bean.setCar_d_seq	(rs.getString("CAR_D_SEQ"));
			    bean.setCar_d_dt	(rs.getString("CAR_D_DT"));
			    bean.setCar_d_p		(rs.getInt   ("CAR_D_P"));
			    bean.setCar_d_per	(rs.getFloat ("CAR_D_PER"));
			    bean.setCar_d_p2	(rs.getInt   ("CAR_D_P2"));
			    bean.setCar_d_per2	(rs.getFloat ("CAR_D_PER2"));
				bean.setLs_yn		(rs.getString("LS_YN"));
				bean.setCar_d		(rs.getString("CAR_D"));
				bean.setCar_d_per_b	(rs.getString("CAR_D_PER_B"));
				bean.setCar_d_per_b2(rs.getString("CAR_D_PER_B2"));
				bean.setCar_d_dt2	(rs.getString("CAR_D_DT2"));
            }
            
            rs.close();
            stmt.close();


        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCarDcNewCase]"+se);	
			System.out.println("[AddCarMstDatabase:getCarDcNewCase]"+query);	
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 차종별 선택사양 조회.
     */
    public CarDcBean getCarDcBaseCase(String car_comp_id, String car_cd, String car_d_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        CarDcBean bean = new CarDcBean();

        query = " SELECT * FROM car_dc "+
				" where  car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_d_dt='"+car_d_dt+"' and replace(car_d,' ','') like '%판매자정상조건%' "+	
				" ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){	            
			    bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_u_seq	(rs.getString("CAR_B_DT"));
				bean.setCar_d_seq	(rs.getString("CAR_D_SEQ"));
			    bean.setCar_d_dt	(rs.getString("CAR_D_DT"));
			    bean.setCar_d_p		(rs.getInt   ("CAR_D_P"));
			    bean.setCar_d_per	(rs.getFloat ("CAR_D_PER"));
			    bean.setCar_d_p2	(rs.getInt   ("CAR_D_P2"));
			    bean.setCar_d_per2	(rs.getFloat ("CAR_D_PER2"));
				bean.setLs_yn		(rs.getString("LS_YN"));
				bean.setCar_d		(rs.getString("CAR_D"));
				bean.setCar_d_per_b	(rs.getString("CAR_D_PER_B"));
				bean.setCar_d_per_b2(rs.getString("CAR_D_PER_B2"));
				bean.setCar_d_dt2	(rs.getString("CAR_D_DT2"));
            }
            
            rs.close();
            stmt.close();


        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCarDcBaseCase]"+se);	
			System.out.println("[AddCarMstDatabase:getCarDcBaseCase]"+query);	
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 차종별 선택사양 조회.
     */
    public CarDcBean getCarDcBaseCase(String car_comp_id, String car_cd, String car_d_dt, String car_b_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        CarDcBean bean = new CarDcBean();

        query = " SELECT * FROM car_dc "+
				" where  car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_b_dt='"+car_b_dt+"' and car_d_dt='"+car_d_dt+"' and replace(car_d,' ','') like '%판매자정상조건%' AND NVL(hp_flag,'Y')='Y' "+	
				" ";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){	            
			    bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_u_seq	(rs.getString("CAR_B_DT"));
				bean.setCar_d_seq	(rs.getString("CAR_D_SEQ"));
			    bean.setCar_d_dt	(rs.getString("CAR_D_DT"));
			    bean.setCar_d_p		(rs.getInt   ("CAR_D_P"));
			    bean.setCar_d_per	(rs.getFloat ("CAR_D_PER"));
			    bean.setCar_d_p2	(rs.getInt   ("CAR_D_P2"));
			    bean.setCar_d_per2	(rs.getFloat ("CAR_D_PER2"));
				bean.setLs_yn		(rs.getString("LS_YN"));
				bean.setCar_d		(rs.getString("CAR_D"));
				bean.setCar_d_per_b	(rs.getString("CAR_D_PER_B"));
				bean.setCar_d_per_b2(rs.getString("CAR_D_PER_B2"));
				bean.setCar_d_dt2	(rs.getString("CAR_D_DT2"));
            }
            
            rs.close();
            stmt.close();


        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCarDcBaseCase]"+se);	
			System.out.println("[AddCarMstDatabase:getCarDcBaseCase]"+query);	
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }


	/**
     * 제조사DC 등록.
     */
    public int insertCarDc(CarDcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " INSERT INTO CAR_DC "+
				" ( CAR_COMP_ID, CAR_CD, CAR_B_DT, CAR_D_SEQ, CAR_D_DT, CAR_D_P, CAR_D_PER, CAR_D_P2, CAR_D_PER2, LS_YN, CAR_D, CAR_D_PER_B, CAR_D_PER_B2, car_d_dt2, car_d_etc, esti_d_etc, HP_FLAG ) \n"	//제조사DC 비고 추가(2018.01.22)
				+ " SELECT ?, ?, ?, nvl(lpad(max(CAR_D_SEQ)+1,2,'0'),'01'), replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, ? \n"
				+ " FROM CAR_DC where car_comp_id=? and car_cd=? and car_b_dt=? \n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id	().trim());
            pstmt.setString(2, bean.getCar_cd		().trim());
			pstmt.setString(3, bean.getCar_u_seq	().trim());
            pstmt.setString(4, bean.getCar_d_dt		().trim());
			pstmt.setInt   (5, bean.getCar_d_p		());
			pstmt.setFloat (6, bean.getCar_d_per	());
			pstmt.setInt   (7, bean.getCar_d_p2		());
			pstmt.setFloat (8, bean.getCar_d_per2	());
			pstmt.setString(9, bean.getLs_yn		().trim());
            pstmt.setString(10,bean.getCar_d		().trim());
			pstmt.setString(11,bean.getCar_d_per_b	().trim());
			pstmt.setString(12,bean.getCar_d_per_b2	().trim());
			pstmt.setString(13,bean.getCar_d_dt2	().trim());
			pstmt.setString(14,bean.getCar_d_etc	().trim());		//제조사DC 비고 추가(2018.01.22)
			pstmt.setString(15,bean.getEsti_d_etc	().trim());
			pstmt.setString(16,bean.getHp_flag      ().trim());
            pstmt.setString(17,bean.getCar_comp_id	().trim());
			pstmt.setString(18,bean.getCar_cd		().trim());
			pstmt.setString(19,bean.getCar_u_seq	().trim());
            count = pstmt.executeUpdate();
                    
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:insertCarDc]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 제조사DC 수정.
     */
    public int updateCarDc(CarDcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_DC SET"+
				" CAR_D_DT		=replace(?,'-',''), "+
				" CAR_D_P		=?, "+
				" CAR_D_PER		=?, "+
				" CAR_D_P2		=?, "+
				" CAR_D_PER2	=?, "+
				" LS_YN			=?, "+
				" CAR_D			=?, "+
				" CAR_D_PER_B	=?, "+
				" CAR_D_PER_B2	=?, "+
				" CAR_D_DT2		=replace(?,'-',''), "+
				" CAR_D_ETC		=?, "+						//제조사DC 비고 추가(2018.01.22)
				" ESTI_D_ETC		=?, "+
				" HP_FLAG       =?  "+
				" WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_B_DT=? AND CAR_D_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);            
			pstmt.setString(1, bean.getCar_d_dt		().trim());
			pstmt.setInt   (2, bean.getCar_d_p		());
			pstmt.setFloat (3, bean.getCar_d_per	());
			pstmt.setInt   (4, bean.getCar_d_p2		());
			pstmt.setFloat (5, bean.getCar_d_per2	());
			pstmt.setString(6, bean.getLs_yn		().trim());
			pstmt.setString(7, bean.getCar_d		().trim());
			pstmt.setString(8, bean.getCar_d_per_b	().trim());
			pstmt.setString(9, bean.getCar_d_per_b2	().trim());
			pstmt.setString(10,bean.getCar_d_dt2	().trim());
			pstmt.setString(11,bean.getCar_d_etc	().trim());		//제조사DC 비고 추가(2018.01.22)
			pstmt.setString(12,bean.getEsti_d_etc	().trim());
			pstmt.setString(13,bean.getHp_flag      ().trim());
            pstmt.setString(14,bean.getCar_comp_id	().trim());
            pstmt.setString(15,bean.getCar_cd		().trim());
            pstmt.setString(16,bean.getCar_u_seq	().trim());
			pstmt.setString(17,bean.getCar_d_seq	().trim());
            count = pstmt.executeUpdate();   
         
            pstmt.close();          
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarDc]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 제조사DC 삭제.
     */
    public int deleteCarDc(CarDcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM CAR_DC WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_B_DT=? AND CAR_D_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);     
            pstmt.setString(1, bean.getCar_comp_id().trim());						
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_u_seq().trim());
			pstmt.setString(4, bean.getCar_d_seq().trim());
            count = pstmt.executeUpdate();   
           
            pstmt.close();          
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarDc]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }



	/**
     * 차명 한건 조회.
     */
    public CarMstBean getCarEtcNmCase(String m_id, String l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        CarMstBean bean = new CarMstBean();
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.dpm"+
				" FROM car_mng a, code b, car_nm c, car_etc d"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001' and c.car_id=d.car_id and c.car_seq=d.car_seq"+
				" and d.rent_mng_id='"+m_id+"' and d.rent_l_cd='"+l_cd+"'";
      
		query += " order by c.car_name";

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));
				bean.setDpm(rs.getInt("DPM"));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	//기본사양조회-------------------------------------------------------------------------------------------------------------------

	/**
     * 기본사양 조회.팝업보여주기
     */
    public Hashtable getCar_b(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
        
        query = " SELECT b.car_name, a.levelnum, 100+(a.levelnum*20) left, 100+(a.levelnum*20) top, b.car_b_inc_id, b.car_b_inc_seq, b.car_b "+
				" FROM "+
				"	(SELECT MAX(level) levelnum "+
				"	   FROM car_nm "+
				"	 CONNECT BY PRIOR car_id=car_b_inc_id "+
				"		    AND PRIOR car_seq=car_b_inc_seq "+
				"     START WITH car_b_inc_id = '"+car_id+"' "+
				"	        AND car_b_inc_seq = '"+car_seq+"' "+
				"	) a, "+
				"	(SELECT car_b_inc_id, car_b_inc_seq, car_b, car_name FROM car_nm WHERE car_id='"+car_id+"' AND car_seq='"+car_seq+"') b ";

		try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();
            if(rs.next()){
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCar_b]"+se);
			System.out.println("[AddCarMstDatabase:getCar_b]"+query);
			 throw new DatabaseException(query);
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
	}

	//차명조회-------------------------------------------------------------------------------------------------------------------
	/**
     * 기본사양 등록시 포함차종 선택할 수 있게 팝업으로 리스트 보여주기
     */
    public Vector getCar_nmList(String car_comp_id, String car_cd, String car_b_dt) throws DatabaseException, DataSourceEmptyException{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
        
        query = " SELECT a.car_id, a.car_seq, b.car_name, TO_CHAR(b.car_b_p,'999,999,999') car_b_p, car_b_dt "+
				"   FROM ( SELECT car_id, MAX(car_seq) car_seq FROM car_nm WHERE car_comp_id='"+car_comp_id+"' AND car_cd='"+car_cd+"' GROUP BY car_id) a, car_nm b "+
				"  WHERE a.car_id = b.car_id AND a.car_seq = b.car_seq ";

//		if(!car_b_dt.equals("")) query += " and b.car_b_dt=replace('"+car_b_dt+"','-','')";

		query += " and b.use_yn='Y'";

		query += " order by b.car_name, b.car_b_p ";


        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();   
            while(rs.next()){
			    Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
            stmt.close();
		}catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
	}

	/**
     * 기본사양 포함 차종명 조회.
     */
    public String getCar_b_inc_name(String car_b_inc_id, String car_b_inc_seq) throws DatabaseException, DataSourceEmptyException{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		String car_b_inc_name = "";
        String query = "";
        
        query = " SELECT car_name FROM car_nm WHERE car_id='"+car_b_inc_id+"' and car_seq='"+car_b_inc_seq+"' ";


        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
			    car_b_inc_name = rs.getString(1)==null?"":rs.getString(1);
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return car_b_inc_name;
	}

    /**
	 *	코드 리스트()
	 */
	public Vector getSearchCodeNew(String car_comp_id, String code, String car_id, String view_dt, String mode, String a_a, String car_origin) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(mode.equals("0")){//자동차제조사 리스트

			query = " select * from CODE where c_st='0001' and code<>'0000'";
			
			if(!car_origin.equals("")) query += " and app_st='"+car_origin+"'";

			query += " ORDER BY NM";
			
		}else if(mode.equals("1")){//차종코드 리스트

			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('마이티Ⅱ','포터')";
			
			query += " ORDER BY CAR_NM";

		}else if(mode.equals("2")){//차명 리스트-차종으로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt >='20040101' ORDER BY CAR_NAME";

		}else if(mode.equals("3")){//기준월 리스트

			query = " select DISTINCT car_b_dt from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("4")){//차명 리스트-기준월로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt =replace('"+view_dt+"', '-', '') ORDER BY CAR_NAME";

		}else if(mode.equals("10")){//차명 리스트-기준월로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt =replace('"+view_dt+"', '-', '') ORDER BY CAR_NAME";

		}else if(mode.equals("5")){//선택사양 - 기준월 리스트

			query = " select DISTINCT car_s_dt from CAR_SEL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("9")){//선택사양 - 기준월 리스트

			query = " select DISTINCT car_s_dt from CAR_OPT where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and car_id='"+car_id+"'";

		}else if(mode.equals("6")){//색상 - 기준월 리스트

			query = " select DISTINCT car_c_dt from CAR_COL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("7")){//제조사DC - 기준월 리스트

//			query = " select DISTINCT car_d_dt from CAR_DC where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("8")){//차종코드 리스트-견적여부

			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y' and nvl(est_yn,'Y')='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('SUT무쏘','마이티Ⅱ','포터')";
			
			query += " ORDER BY CAR_NM";

		}				
		
		try {
		    pstmt = con.prepareStatement(query);
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
		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getSearchCodeNew]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	코드 리스트()
	 */
	public Vector getSearchCodeNew(String car_comp_id, String code, String car_id, String view_dt, String mode, String a_a, String car_origin, String s_st, String car_st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(mode.equals("0")){//자동차제조사 리스트

			query = " select * from CODE where c_st='0001' and code<>'0000'";
			
			if(!car_origin.equals("")) query += " and app_st='"+car_origin+"'";

			query += " ORDER BY NM";
			
		}else if(mode.equals("1")){//차종코드 리스트

			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' ";

			if(!car_st.equals("2")) query += " and use_yn='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('마이티Ⅱ','포터')";

			if(!s_st.equals("")) query += " and code in (select car_cd from car_nm where car_comp_id='"+car_comp_id+"' and s_st='"+s_st+"' group by car_cd)";
			
			query += " ORDER BY CAR_NM";

		}else if(mode.equals("2")){//차명 리스트-차종으로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt >='20040101' ORDER BY CAR_NAME";

		}else if(mode.equals("3")){//기준월 리스트

			query = " select DISTINCT car_b_dt from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("4")){//차명 리스트-기준월로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt =replace('"+view_dt+"', '-', '') ORDER BY CAR_NAME";

		}else if(mode.equals("10")){//차명 리스트-기준월로

			query = " select * from CAR_NM where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and use_yn='Y' and car_b_dt =replace('"+view_dt+"', '-', '') ORDER BY CAR_NAME";

		}else if(mode.equals("5")){//선택사양 - 기준월 리스트

			query = " select DISTINCT car_s_dt from CAR_SEL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("9")){//선택사양 - 기준월 리스트

			query = " select DISTINCT car_s_dt from CAR_OPT where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and car_id='"+car_id+"'";

		}else if(mode.equals("6")){//색상 - 기준월 리스트

			query = " select DISTINCT car_c_dt from CAR_COL where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("7")){//제조사DC - 기준월 리스트

//			query = " select DISTINCT car_d_dt from CAR_DC where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"'";

		}else if(mode.equals("8")){//차종코드 리스트-견적여부

			query = " select * from CAR_MNG where car_comp_id='"+car_comp_id+"' and use_yn='Y' and nvl(est_yn,'Y')='Y'";

			if(a_a.equals("1")) query += " and car_nm not like '%LPG%'";
			if(a_a.equals("2")) query += " and car_nm not like '%밴%' and car_nm not in ('SUT무쏘','마이티Ⅱ','포터')";
			
			query += " ORDER BY CAR_NM";

		}				
		
		try {
		    pstmt = con.prepareStatement(query);
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
		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getSearchCodeNew]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	차명 엑셀 리스트
	 */
	public Vector getCarNmExcelList(String car_comp_id, String code, String car_name, String view_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*, b.nm, c.car_nm "+
		        " from   car_nm a, (select * from code where c_st='0001') b, car_mng c "+
				" where  a.car_comp_id='"+car_comp_id+"' and a.car_comp_id=b.code and a.car_comp_id=c.car_comp_id and a.car_cd=c.code and a.car_b_dt > '19991231' ";//and a.car_cd='"+code+"' 
		
		if(!code.equals(""))		query += " and a.car_cd='"+code+"'";
		if(!car_name.equals(""))	query += " and a.car_name='"+car_name+"'";
		if(!view_dt.equals(""))		query += " and a.car_b_dt=replace('"+view_dt+"','-','')";

		query += " order by a.car_cd, a.car_b_dt, a.jg_code, a.car_b_p";
			
		
		try {
		    pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarNmExcelList]"+e);
			System.out.println("[AddCarMstDatabase:getCarNmExcelList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
    /**
	 *	차명 엑셀 리스트
	 */
	public Vector getCarNmExcelList2(String car_comp_id, String code, String car_name, String view_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*, b.nm, c.car_nm "+
		        " from   car_nm a, (select * from code where c_st='0001') b, car_mng c "+
				" where  a.car_comp_id='"+car_comp_id+"' AND a.use_yn='Y' and a.car_comp_id=b.code and a.car_comp_id=c.car_comp_id and a.car_cd=c.code "; 
		
		if(!code.equals(""))		query += " and a.car_cd='"+code+"'";
		if(!car_name.equals(""))	query += " and a.car_name='"+car_name+"'";
		if(!view_dt.equals(""))		query += " and a.car_b_dt=replace('"+view_dt+"','-','')";

		query += " order by a.car_cd, a.car_b_dt, a.jg_code, a.car_b_p";
			
		
		try {
		    pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarNmExcelList]"+e);
			System.out.println("[AddCarMstDatabase:getCarNmExcelList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}	

    /**
	 *	차명 엑셀 리스트
	 */
	public Hashtable getCarNmExcelCase(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " select a.*, b.nm, c.car_nm from car_nm a, (select * from code where c_st='0001') b, car_mng c where a.car_id='"+car_id+"' and a.car_seq='"+car_seq+"' and a.car_comp_id=b.code and a.car_comp_id=c.car_comp_id and a.car_cd=c.code ";					
		
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   
			
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}

			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarNmExcelCase]"+e);
			System.out.println("[AddCarMstDatabase:getCarNmExcelCase]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

    /**
	 *	차명 엑셀 리스트
	 */
	public Vector getCarNmExcelRentList(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select b.*, c.firm_nm, d.car_no, d.init_reg_dt, e.cls_st, e.cls_dt "+
				" from car_etc a, cont b, client c, car_reg d, cls_cont e"+
				" where a.car_id='"+car_id+"' and a.car_seq='"+car_seq+"' "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and b.client_id=c.client_id "+
				" and b.car_mng_id=d.car_mng_id(+) "+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) ";
		

		query += " order by d.init_reg_dt, b.rent_dt";
			
		
		try {
		    pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarNmExcelRentList]"+e);
			System.out.println("[AddCarMstDatabase:getCarNmExcelRentList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	선택사양 최대건수
	 */
	public int getMaxCarSseq() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";


		query = " select to_number(max(car_s_seq)) from car_opt ";					
		
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			
			if(rs.next())
			{				
				cnt = rs.getInt(1);
			}

			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getMaxCarSseq]"+e);
			System.out.println("[AddCarMstDatabase:getMaxCarSseq]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return cnt;
	}

    /**
     * 차종코드 변경으로 관련한 계약 수정
     */
    public int updateRentCarId(String car_id, String car_seq, String cng_car_id, String cng_car_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update CAR_ETC set car_id=?, car_seq=? where car_id=? and car_seq=?";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);     
            pstmt.setString(1, cng_car_id);						
            pstmt.setString(2, cng_car_seq);
            pstmt.setString(3, car_id);
            pstmt.setString(4, car_seq);
            count = pstmt.executeUpdate();   
           
            pstmt.close();          
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateRentCarId]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 차종코드 변경으로 관련한 계약 수정
     */
    public int deleteCarId(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " delete CAR_NM where car_id=? and car_seq=?";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);     
            pstmt.setString(1, car_id);
            pstmt.setString(2, car_seq);
            count = pstmt.executeUpdate();   
           
            pstmt.close();          
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarId]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
	 *	차명 조회
	 */
	public String getCarNmCd(String car_comp_nm, String car_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_cd = "";
		String query = "";


		query = " select a.code from car_mng a, (select * from code where c_st='0001' and replace(nm,'(주)','') =replace(replace(?,'(주)',''),'㈜','')) b where a.car_comp_id=b.code and a.car_nm=?";
		
		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_comp_nm.trim());
            pstmt.setString(2, car_nm.trim());
	    	rs = pstmt.executeQuery();
			
			if(rs.next())
			{				
				car_cd = rs.getString(1);
			}

			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarNmCd]"+e);
			System.out.println("[AddCarMstDatabase:getCarNmCd]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return car_cd;
	}

    /**
	 *	제조사코드 조회
	 */
	public String getCarCompCd(String car_comp_nm, String car_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_comp_id = "";
		String query = "";


		query = " select a.car_comp_id from car_mng a, (select * from code where c_st='0001' and nm =?) b where a.car_comp_id=b.code and a.car_nm=?";
		
		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_comp_nm.trim());
            pstmt.setString(2, car_nm.trim());
	    	rs = pstmt.executeQuery();
			
			if(rs.next())
			{				
				car_comp_id = rs.getString(1);
			}

			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarCompCd]"+e);
			System.out.println("[AddCarMstDatabase:getCarCompCd]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return car_comp_id;
	}

    /**
	 *	제조사코드 조회
	 */
	public String getCarCompCd(String car_comp_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_comp_id = "";
		String query = "";


		query = " select code from code where c_st='0001' and replace(nm,'(주)','') =replace(replace(?,'(주)',''),'㈜','') AND NVL(cms_bk,'Y') <>'N'";
		
		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_comp_nm.trim());
	    	rs = pstmt.executeQuery();
			
			if(rs.next())
			{				
				car_comp_id = rs.getString(1);
			}

			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarCompCd(String car_comp_nm)]"+e);
			System.out.println("[AddCarMstDatabase:getCarCompCd(String car_comp_nm)]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return car_comp_id;
	}

    /**
     * 차명 수정.
     */
    public int updateCarNm2(CarMstBean bean, String cng_car_cd, String cng_car_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
		int idx = 0;
                
        query = " UPDATE CAR_NM SET "+
				        " CAR_NAME=?, USE_YN=?, CAR_B='"+bean.getCar_b().trim()+"', CAR_B_P=?, CAR_B_DT=replace(?,'-',''),"+
					    " SECTION=?, DPM=?, MAX_LE_36=?, MAX_LE_24=?, MAX_LE_12=?, MAX_RE_36=?, MAX_RE_24=?, MAX_RE_18=?, S_ST=?, EST_YN=?, CAR_B_INC_ID=?, CAR_B_INC_SEQ=?, SH_CODE=?, DIESEL_YN=?, AUTO_YN=?, JG_CODE=?, "+
						" air_ds_yn		= ?, "+
						" air_as_yn		= ?, "+
						" air_cu_yn		= ?, "+
						" abs_yn 		= ?, "+
						" rob_yn		= ?, "+
						" sp_car_yn		= ?, END_DT=?";

		if(!cng_car_cd.equals(""))	query += ", car_cd=?";

		if(!cng_car_id.equals("") && !bean.getCar_id().equals(cng_car_id))	query += ", car_id=?, car_seq=(select nvl(lpad(max(CAR_SEQ)+1,2,'0'),'01') from car_nm where car_id=?) ";

		query +=		" , hp_yn=? \n";

		query +=		" WHERE CAR_ID=? AND CAR_SEQ=?\n";
           
       try{

            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getCar_name().trim());
            pstmt.setString(2, bean.getCar_yn().trim());
			pstmt.setInt   (3, bean.getCar_b_p());
			pstmt.setString(4, bean.getCar_b_dt().trim());
            pstmt.setString(5, bean.getSection().trim());
            pstmt.setInt   (6, bean.getDpm());
            pstmt.setInt   (7, bean.getMax_le_36());
            pstmt.setInt   (8, bean.getMax_le_24());
            pstmt.setInt   (9, bean.getMax_le_12());
            pstmt.setInt   (10, bean.getMax_re_36());
            pstmt.setInt   (11, bean.getMax_re_24());
            pstmt.setInt   (12, bean.getMax_re_18());
            pstmt.setString(13, bean.getS_st().trim());
            pstmt.setString(14, bean.getEst_yn().trim());
			pstmt.setString(15, bean.getCar_b_inc_id());
			pstmt.setString(16, bean.getCar_b_inc_seq());
			pstmt.setString(17, bean.getSh_code().trim());
			pstmt.setString(18, bean.getDiesel_yn().trim());
			pstmt.setString(19, bean.getAuto_yn().trim());
			pstmt.setString(20, bean.getJg_code().trim());
			pstmt.setString(21, bean.getAir_ds_yn	());
			pstmt.setString(22, bean.getAir_as_yn	());
			pstmt.setString(23, bean.getAir_cu_yn	());
			pstmt.setString(24, bean.getAbs_yn 		());
			pstmt.setString(25, bean.getRob_yn		());
			pstmt.setString(26, bean.getSp_car_yn	());
			pstmt.setString(27, bean.getEnd_dt		());

			idx = 27;

			if(!cng_car_cd.equals("")){
				idx++;
				pstmt.setString(idx, cng_car_cd);
			}

			if(!cng_car_id.equals("") && !bean.getCar_id().equals(cng_car_id)){
				idx++;	
				pstmt.setString(idx, cng_car_id);
				idx++;
				pstmt.setString(idx, cng_car_id);
			}

			idx++;
			pstmt.setString(idx, bean.getHp_yn().trim());

			idx++;
			pstmt.setString(idx, bean.getCar_id().trim());
			idx++;
            pstmt.setString(idx, bean.getCar_seq().trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();


        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarNm2]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 옵션 수정.
     */
    public int updateCarOpt2(CarMstBean bean, CarMstBean bean2, String cng_car_cd, String cng_car_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
		int idx = 0;
                
        query = " UPDATE CAR_OPT SET "+
				        " CAR_COMP_ID=?";

		if(!cng_car_cd.equals(""))	query += ", car_cd=?";

		if(!cng_car_id.equals("") && !bean.getCar_id().equals(cng_car_id))	query += ", car_id=?, car_u_seq=? ";

		query +=		" WHERE CAR_ID=? AND CAR_U_SEQ=?\n";
           
       try{

            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getCar_comp_id().trim());

			idx = 1;

			if(!cng_car_cd.equals("")){
				idx++;
				pstmt.setString(idx, cng_car_cd);
			}

			if(!cng_car_id.equals("") && !bean.getCar_id().equals(cng_car_id)){
				idx++;	
				pstmt.setString(idx, cng_car_id);
				idx++;
				pstmt.setString(idx, bean2.getCar_seq().trim());
			}

			idx++;
			pstmt.setString(idx, bean.getCar_id().trim());
			idx++;
            pstmt.setString(idx, bean.getCar_seq().trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();


        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarOpt2]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 계약 수정.
     */
    public int updateCarEctCd(CarMstBean bean, CarMstBean bean2, String cng_car_cd, String cng_car_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_ETC SET car_id=?, car_seq=?  WHERE CAR_ID=? AND CAR_SEQ=?";
           
       try{

            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            

			pstmt.setString(1, cng_car_id);
			pstmt.setString(2, bean2.getCar_seq().trim());
			pstmt.setString(3, bean.getCar_id().trim());
            pstmt.setString(4, bean.getCar_seq().trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();


        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarEctCd]"+se);
				System.out.println("[AddCarMstDatabase:updateCarEctCd]"+query);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
	 *	차명 조회
	 */
	public String getCarNmId() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_id = "";
		String query = "";


		query = " select nvl(lpad(max(car_id)+1,6,'0'),'000001') from car_nm";
		
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			
			if(rs.next())
			{				
				car_id = rs.getString(1);
			}

			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarNmId]"+e);
			System.out.println("[AddCarMstDatabase:getCarNmId]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return car_id;
	}

    /**
	 *	코드 리스트()
	 */
	public Vector getSearchShCode(String car_comp_id, String code, String car_id, String view_dt, String mode, String cars) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(mode.equals("1")){		//차종

			
			query = " select code, car_nm "+
				    " from CAR_MNG "+
					" where car_comp_id='"+car_comp_id+"' "+
					" order by car_nm";
			

		}else if(mode.equals("2")){	//엔진구분(차종코드)


			query = " select a.jg_code, max(b.cars) cars "+
					" from CAR_NM a, esti_jg_var b "+
					" where a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+code+"' and a.jg_code=b.sh_code "+
					" group by a.jg_code order by a.jg_code";
			

		}else if(mode.equals("3")){	//기준일자


			query = " select car_b_dt "+
					" from CAR_NM "+
					" where car_comp_id='"+car_comp_id+"' and car_cd='"+code+"' and jg_code='"+cars+"'"+
					" group by car_b_dt  order by car_b_dt ";
		

		}else if(mode.equals("4")){	//모델

			String car_e_dt = "nvl(to_char(to_date(b.car_b_dt,'YYYYMMDD')-1,'YYYYMMDD'),'99999999')";

			query = " select a.*, "+car_e_dt+" as car_e_dt"+
					" from car_nm a, car_nm b"+
					" where a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+code+"' and a.jg_code='"+cars+"'"+
					" and a.car_id=b.car_id(+) and lpad(to_number(a.car_seq)+1,2,'0')=b.car_seq(+)";

			if(view_dt.length() == 6)	query += " '"+view_dt+"' between substr(a.car_b_dt,1,6) and substr("+car_e_dt+",1,6)";
			if(view_dt.length() == 4)	query += " '"+view_dt+"' between substr(a.car_b_dt,1,4) and substr("+car_e_dt+",1,4)";

			query += " order by b.car_b_dt, b.car_b_p";

		}				
		
		try {
		    pstmt = con.prepareStatement(query);
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
		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getSearchShCode]"+e);
			System.out.println("[AddCarMstDatabase:getSearchShCode]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	출고탁송 엑셀폼 리스트
	 */
	public Vector getConsCostCarForm() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.car_comp_id, a.car_cd, c.nm, b.car_nm"+
				" from"+
				" (select car_comp_id, car_cd from car_nm where use_yn='Y' and est_yn='Y' group by car_comp_id, car_cd) a, car_mng b,"+
				" (select * from code where c_st='0001') c"+
				" where a.car_comp_id=b.car_comp_id and a.car_cd=b.code"+
				" and a.car_comp_id=c.code and c.app_st='1'"+
				" order by a.car_comp_id, b.ab_nm";
			
		
		try {
		    pstmt = con.prepareStatement(query);
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
		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getConsCostCarForm]"+e);
			System.out.println("[AddCarMstDatabase:getConsCostCarForm]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	차명 엑셀 리스트
	 */
	public Vector getCarNmExcelYnList(String car_comp_id, String code, String car_name, String view_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*, b.nm, c.car_nm from car_nm a, (select * from code where c_st='0001') b, car_mng c where a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+code+"' and a.car_comp_id=b.code and a.car_comp_id=c.car_comp_id and a.car_cd=c.code and a.car_b_dt > '19991231' ";
		
		if(!car_name.equals("") && !car_name.equals("선택"))	query += " and a.car_name='"+car_name+"'";
		if(!view_dt.equals(""))		query += " and a.car_b_dt=replace('"+view_dt+"','-','')";


		query += " order by a.car_b_dt, a.jg_code, a.car_b_p";
			
		
		try {
		    pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarNmExcelYnList]"+e);
			System.out.println("[AddCarMstDatabase:getCarNmExcelYnList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
     * 차명 수정.
     */
    public int updateCarNmYn(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_NM SET USE_YN='N', EST_YN='N', HP_YN='N' WHERE CAR_ID=? AND CAR_SEQ=?";
           
       try{

            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
			pstmt.setString(1, car_id.trim());
            pstmt.setString(2, car_seq.trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();


        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarNmYn]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 차명 수정.
     */
    public int updateCarNmYn2(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_NM SET USE_YN='Y', EST_YN='Y', HP_YN='Y' WHERE CAR_ID=? AND CAR_SEQ=?";
           
       try{

            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
			pstmt.setString(1, car_id.trim());
            pstmt.setString(2, car_seq.trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();


        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarNmYn2]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 차명 수정.
     */
    public int updateCarNmYn(String car_id, String car_seq, String use_yn, String est_yn, String hp_yn, String end_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_NM SET USE_YN=?, EST_YN=?, hp_yn=?, end_dt=? WHERE CAR_ID=? AND CAR_SEQ=?";
           
       try{

            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
			pstmt.setString(1, use_yn.trim());
            pstmt.setString(2, est_yn.trim());
			pstmt.setString(3, hp_yn.trim());
			pstmt.setString(4, end_dt.trim());
			pstmt.setString(5, car_id.trim());
            pstmt.setString(6, car_seq.trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();


        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarNmYn]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 차명 수정.
     */
    public int updateCarNmYn(String car_id, String car_seq, String use_yn, String est_yn, String hp_yn, String end_dt, String jg_tuix_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_NM SET USE_YN=?, EST_YN=?, hp_yn=?, end_dt=?, jg_tuix_st=? WHERE CAR_ID=? AND CAR_SEQ=?";
           
       try{

            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
			pstmt.setString(1, use_yn.trim());
            pstmt.setString(2, est_yn.trim());
			pstmt.setString(3, hp_yn.trim());
			pstmt.setString(4, end_dt.trim());
			pstmt.setString(5, jg_tuix_st.trim());
			pstmt.setString(6, car_id.trim());
            pstmt.setString(7, car_seq.trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();


        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarNmYn]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll3(String car_comp_id, String code, String car_id, String view_dt, String t_wd, String t_wd2, String t_wd3, String t_wd4, String t_wd5, String gubun1) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.CAR_B_INC_ID, c.CAR_B_INC_SEQ, c.est_yn, c.s_st, c.jg_code "+
				" FROM car_mng a, code b, car_nm c"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001'";// and c.car_b_dt>='20040101'

		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"'";
		if(!code.equals(""))		query += " and c.car_cd = '"+code+"'";
		if(!car_id.equals(""))		query += " and c.car_id = '"+car_id+"'";
		if(!view_dt.equals(""))		query += " and c.car_b_dt = '"+view_dt+"'";
		if(view_dt.equals(""))		query += " and c.car_b_dt>='20040101'";
		if(!t_wd.equals(""))		query += " and a.car_nm||c.car_name like '%"+t_wd+"%"+t_wd2+"%"+t_wd3+"%'";
		if(!t_wd4.equals(""))		query += " and c.car_b_p like '%"+t_wd4+"%'";
		if(!t_wd5.equals(""))		query += " and c.jg_code like '%"+t_wd5+"%'";
		if(gubun1.equals("Y"))		query += " and c.use_yn='Y'";
		if(gubun1.equals("N"))		query += " and c.use_yn='N'";

		//query += " order by c.car_name ";

		query += " order by substr(c.jg_code,1,3), c.car_b_p ";



        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));
				bean.setCar_b_inc_id(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq(rs.getString("CAR_B_INC_SEQ"));
				bean.setEst_yn(rs.getString("EST_YN"));
				bean.setJg_code(rs.getString("JG_CODE"));
				bean.setS_st(rs.getString("S_ST"));

				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }

    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll3(String car_comp_id, String code, String t_wd, String t_wd2, String t_wd3, String t_wd4, String t_wd5, String gubun1) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, C.est_yn, C.car_b_inc_id, C.car_b_inc_seq, c.s_st, c.jg_code"+
				" FROM car_mng a, code b, car_nm c,"+
				" (select car_comp_id, car_cd, car_id, max(car_seq) car_seq from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id) d"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001'"+
				" and c.car_b_dt>='20040101'";

		if(!t_wd5.equals("")){
			query += " and c.car_comp_id=d.car_comp_id(+) and c.car_cd=d.car_cd(+) and c.car_id=d.car_id(+) and c.car_seq=d.car_seq(+)";
		}else{
			query += " and c.car_comp_id=d.car_comp_id and c.car_cd=d.car_cd and c.car_id=d.car_id and c.car_seq=d.car_seq";
		}
		

		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"'";
		if(!code.equals(""))		query += " and c.car_cd = '"+code+"'";
		if(!t_wd.equals(""))		query += " and a.car_nm||c.car_name like '%"+t_wd+"%"+t_wd2+"%"+t_wd3+"%'";
		if(!t_wd4.equals(""))		query += " and c.car_b_p like '%"+t_wd4+"%'";
		if(!t_wd5.equals(""))		query += " and c.jg_code like '%"+t_wd5+"%'";
//		if(gubun1.equals("Y"))		query += " and c.use_yn='Y'";
//		if(gubun1.equals("N"))		query += " and c.use_yn='N'";

		//query += " order by c.car_b_p";

		query += " order by substr(c.jg_code,1,3), c.car_b_p ";



        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));
				bean.setEst_yn(rs.getString("EST_YN"));
				bean.setCar_b_inc_id(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq(rs.getString("CAR_B_INC_SEQ"));
				bean.setS_st(rs.getString("S_ST"));
				bean.setJg_code(rs.getString("JG_CODE"));

				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }
    
    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll4(String car_comp_id, String code, String car_id, String view_dt, String t_wd, String t_wd2, String t_wd3, String t_wd4, String t_wd5, String gubun1, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID, c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION,"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.CAR_B_INC_ID, c.CAR_B_INC_SEQ, c.est_yn, c.s_st, c.jg_code, c.car_y_form, c.dpm "+
				" FROM car_mng a, code b, car_nm c"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd"+
				" and a.car_comp_id=b.code and b.c_st = '0001'";// and c.car_b_dt>='20040101'

		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"'";
		if(!code.equals(""))		query += " and c.car_cd = '"+code+"'";
		if(!car_id.equals(""))		query += " and c.car_id = '"+car_id+"'";
		if(!view_dt.equals("") && !view_dt.equals("99999999"))		query += " and c.car_b_dt = '"+view_dt+"'";
		if(view_dt.equals(""))		query += " and c.car_b_dt>='20040101'";
		if(!t_wd.equals(""))		query += " and a.car_nm||c.car_name like '%"+t_wd+"%"+t_wd2+"%"+t_wd3+"%'";
		if(!t_wd4.equals(""))		query += " and c.car_b_p like '%"+t_wd4+"%'";
		if(!t_wd5.equals(""))		query += " and c.jg_code like '%"+t_wd5+"%'";
		if(gubun1.equals("Y"))		query += " and c.use_yn='Y'";
		if(gubun1.equals("N"))		query += " and c.use_yn='N'";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("1"))		query += " order by c.car_name "+sort+" ";
		else if(sort_gubun.equals("2"))	query += " order by c.jg_code "+sort+", c.car_b_p ";
		else if(sort_gubun.equals("3"))	query += " order by c.car_b_p "+sort+", substr(c.jg_code,1,3) ";
		else if(sort_gubun.equals("4"))	query += " order by c.car_b_dt "+sort+", substr(c.jg_code,1,3), c.car_b_p ";
		else if(sort_gubun.equals("5"))	query += " order by c.dpm  "+sort+", substr(c.jg_code,1,3), c.car_b_p ";
		else if(sort_gubun.equals("6"))	query += " order by c.diesel_yn "+sort+", substr(c.jg_code,1,3), c.car_b_p ";

        Collection<CarMstBean> col = new ArrayList<CarMstBean>();

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));
				bean.setCar_b_inc_id(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq(rs.getString("CAR_B_INC_SEQ"));
				bean.setEst_yn(rs.getString("EST_YN"));
				bean.setJg_code(rs.getString("JG_CODE"));
				bean.setS_st(rs.getString("S_ST"));
				bean.setCar_y_form(rs.getString("CAR_Y_FORM"));
				bean.setDpm(rs.getInt("dpm"));

				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }

    /**
     * 차명 조회.
     */
    public CarMstBean [] getCarNmAll4(String car_comp_id, String code, String t_wd, String t_wd2, String t_wd3, String t_wd4, String t_wd5, String gubun1, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD, \n"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION, \n"+
				" c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, C.est_yn, C.car_b_inc_id, C.car_b_inc_seq, c.s_st, c.jg_code, c.car_y_form, c.dpm  \n"+
				" FROM car_mng a, code b, car_nm c, \n"+
				" (select car_comp_id, car_cd, car_id, max(car_seq) car_seq from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id) d \n"+
				" where a.car_comp_id=c.car_comp_id and a.code=c.car_cd \n"+
				" and a.car_comp_id=b.code and b.c_st = '0001' \n"+
				" and c.car_b_dt>='20040101' \n";

		if(!t_wd5.equals("")){
			query += " and c.car_comp_id=d.car_comp_id(+) and c.car_cd=d.car_cd(+) and c.car_id=d.car_id(+) and c.car_seq=d.car_seq(+) \n";
		}else{
			query += " and c.car_comp_id=d.car_comp_id and c.car_cd=d.car_cd and c.car_id=d.car_id and c.car_seq=d.car_seq \n";
		}
		
		if(!car_comp_id.equals(""))	query += " and a.car_comp_id = '"+car_comp_id+"' \n";
		if(!code.equals(""))		query += " and c.car_cd = '"+code+"' \n";
		if(!t_wd.equals(""))		query += " and a.car_nm||c.car_name like '%"+t_wd+"%"+t_wd2+"%"+t_wd3+"%' \n";
		if(!t_wd4.equals(""))		query += " and c.car_b_p like '%"+t_wd4+"%' \n";
		if(!t_wd5.equals(""))		query += " and c.jg_code like '%"+t_wd5+"%' \n";
		if(gubun1.equals("Y"))		query += " and c.use_yn='Y' \n";
		if(gubun1.equals("N"))		query += " and c.use_yn='N' \n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc \n";

		/*정렬조건*/
		if(sort_gubun.equals("1"))		query += " order by c.car_b_dt desc, c.car_name "+sort+"  \n";
		else if(sort_gubun.equals("2"))	query += " order by c.jg_code "+sort+", c.car_b_p  \n";
		else if(sort_gubun.equals("3"))	query += " order by c.car_b_p "+sort+", substr(c.jg_code,1,3)  \n";
		else if(sort_gubun.equals("4"))	query += " order by c.car_b_dt "+sort+", substr(c.jg_code,1,3), c.car_b_p  \n";
		else if(sort_gubun.equals("5"))	query += " order by c.dpm  "+sort+", substr(c.jg_code,1,3), c.car_b_p  \n";
		else if(sort_gubun.equals("6"))	query += " order by c.diesel_yn "+sort+", substr(c.jg_code,1,3), c.car_b_p  \n";


        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
//System.out.println("getCarNmAll4 query :" + query);
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarMstBean bean = new CarMstBean();
			    bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
			    bean.setCar_comp_nm(rs.getString("CAR_COMP_NM"));
			    bean.setCode(rs.getString("CODE"));
				bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_nm(rs.getString("CAR_NM"));
			    bean.setCar_id(rs.getString("CAR_ID"));
			    bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setCar_yn(rs.getString("CAR_YN"));
				bean.setSection(rs.getString("SECTION"));
			    bean.setCar_seq(rs.getString("CAR_SEQ"));
				bean.setCar_b(rs.getString("CAR_B"));
				bean.setCar_b_p(rs.getInt("CAR_B_P"));
				bean.setCar_b_dt(rs.getString("CAR_B_DT"));
				bean.setEst_yn(rs.getString("EST_YN"));
				bean.setCar_b_inc_id(rs.getString("CAR_B_INC_ID"));
				bean.setCar_b_inc_seq(rs.getString("CAR_B_INC_SEQ"));
				bean.setS_st(rs.getString("S_ST"));
				bean.setJg_code(rs.getString("JG_CODE"));
				bean.setCar_y_form(rs.getString("CAR_Y_FORM"));
				bean.setDpm(rs.getInt("dpm"));

				col.add(bean); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarMstBean[])col.toArray(new CarMstBean[0]);
    }

    /**
     * 선택사양 삭제.
     */
    public int deleteCarNm(CarMstBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM CAR_NM WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_ID=? AND CAR_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id().trim());			
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_id().trim());
            pstmt.setString(4, bean.getCar_seq().trim());
            count = pstmt.executeUpdate();      
            
            pstmt.close();       
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarNm]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
	 *	월별 제조사 DC
	 */
	public Vector getCarDcMonList(String st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT DISTINCT B.CAR_NM, a.CAR_D, a.car_d_dt2, a.car_d_p, a.car_d_per, a.car_d_per_b, a.ls_yn, a.car_d_p2, a.car_d_per2, a.car_d_per_b2 "+
				" FROM   CAR_DC a, CAR_MNG b "+
				" WHERE  a.car_comp_id=b.car_comp_id AND a.car_cd=B.CODE ";
		
		if(st.equals("1"))		query += " AND a.car_d_dt=to_char(sysdate,'YYYYMM')||'01' ";
		if(st.equals("2"))		query += " AND a.car_d_dt=to_char(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'01' ";

		query += " order by B.CAR_NM";
			
		
		try {
		    pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarDcMonList]"+e);
			System.out.println("[AddCarMstDatabase:getCarDcMonList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	동일차종 선택사양 등록분 가져오기
	 */
	public Vector getCarOptRegList(String car_comp_id, String car_cd, String view_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT MAX(b.car_s) car_s, b.car_s_p, b.opt_b, MIN(b.car_s_dt) s_dt, MAX(b.car_s_dt) e_dt, min(b.jg_opt_st) jg_opt_st, max(b.jg_tuix_st) jg_tuix_st, max(b.JG_OPT_YN) JG_OPT_YN "+
				"					, max(b.lkas_yn) lkas_yn, max(b.ldws_yn) ldws_yn, max(b.aeb_yn) aeb_yn, max(b.fcw_yn) fcw_yn, max(b.hook_yn) hook_yn "+
                " FROM   CAR_NM a, CAR_OPT b "+
                " WHERE  a.car_comp_id='"+car_comp_id+"' AND a.car_cd='"+car_cd+"' AND a.car_b_dt='"+view_dt+"' AND a.use_yn='Y' "+
                " AND a.car_comp_id=b.car_comp_id AND a.car_cd=b.car_cd AND a.car_id=b.car_id AND a.car_seq=b.CAR_U_SEQ "+
                " GROUP BY REPLACE(b.car_s,' ',''), b.car_s_p, b.opt_b "+
                " ORDER BY REPLACE(b.car_s,' ',''), b.car_s_p, b.opt_b ";			
		
		try {
		    pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarOptRegList]"+e);
			System.out.println("[AddCarMstDatabase:getCarOptRegList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	경매장차명코드변환 조회
	 */
	public Vector getOfflsDataSearchList(String car_name) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT distinct B.CAR_NM, a.car_id, a.jg_code "+
				" FROM   CAR_NM a, CAR_MNG b "+
				" WHERE  a.car_comp_id=b.car_comp_id AND a.car_cd=B.CODE "+
				"        AND REPLACE(UPPER(b.car_nm||a.car_name),' ','') =REPLACE(UPPER('"+car_name+"'),' ','') "+
			    " ";			
		
		try {
		    pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getOfflsDataSearchList]"+e);
			System.out.println("[AddCarMstDatabase:getOfflsDataSearchList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	차종별 색상,사양 조정잔가 리스트
	 */
	public Vector getCarShCodeBdtJgOptList(String sh_code, String b_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.* "+
                " FROM   esti_jg_opt_var a, ( select sh_code, max(reg_dt) reg_dt from esti_jg_opt_var where sh_code='"+sh_code+"' ";
			
		if(!b_dt.equals(""))	query += " and reg_dt <= replace('"+b_dt+"','-','') ";
		
		query += "       GROUP BY sh_code ) b "+
                " WHERE  a.sh_code='"+sh_code+"' AND a.sh_code=b.sh_code AND a.reg_dt=b.reg_dt "+
                " ORDER BY a.jg_opt_st ";
		
		try {
		    pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarShCodeBdtJgOptList]"+e);
			System.out.println("[AddCarMstDatabase:getCarShCodeBdtJgOptList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	/**
     * 차량연비 등록.
     * date : 20160928
     * author : 성승현
     * from : insertCarDc(CarDcBean bean)
     */
    public int insertCarKm(CarKmBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " INSERT INTO CAR_KM "+
				" ( CAR_COMP_ID, CAR_CD, CAR_K_DT, CAR_K_SEQ, ENGINE, CAR_K, CAR_K_ETC, USE_YN ) \n"//8개
				+ " SELECT ?, ?, replace(?,'-',''), nvl(lpad(max(CAR_K_SEQ)+1,2,'0'),'01'), ?, ?, ?, ? \n"
				+ " FROM CAR_KM where car_comp_id=? and car_cd=? and car_k_dt=? \n";
           
       //System.out.println("[AddCarMstDatabase:insertCarKm]"+query);	
        //System.out.println(bean.getCar_comp_id	());
        //System.out.println(bean.getCar_cd	());
        //System.out.println(bean.getCar_k_dt	());
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id	().trim());
            pstmt.setString(2, bean.getCar_cd		().trim());
			//pstmt.setString(3, bean.getCar_k_seq	().trim());
            pstmt.setString(3, bean.getCar_k_dt		().trim());
			pstmt.setString(4, bean.getEngine		().trim());
            pstmt.setString(5,bean.getCar_k		().trim());
			pstmt.setString(6,bean.getCar_k_etc	().trim());
			pstmt.setString(7,bean.getUse_yn	().trim());
            pstmt.setString(8, bean.getCar_comp_id	().trim());
            pstmt.setString(9, bean.getCar_cd		().trim());
            pstmt.setString(10, bean.getCar_k_dt		().trim());
            count = pstmt.executeUpdate();
                    
            pstmt.close(); 
            con.commit();
         

        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:insertCarKm]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 차량연비 조회 
     * date : 20160930
     * author : 성승현
     * from : getCarDcList(String car_comp_id, String car_cd, String car_seq, String view_dt)
     */
    public CarKmBean [] getCarKmList(String car_comp_id, String car_cd, String view_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";


        query = " SELECT * FROM car_km"+
				" where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_k_dt='"+view_dt+"' order by engine, car_k desc ";
	

        Collection col = new ArrayList();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
	            CarKmBean bean = new CarKmBean();
			    bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
			    bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_k_dt		(rs.getString("CAR_K_DT"));
				bean.setCar_k_seq	(rs.getString("CAR_K_SEQ"));
			    bean.setEngine	(rs.getString("ENGINE"));
				bean.setCar_k		(rs.getString("CAR_K"));
				bean.setCar_k_etc	(rs.getString("CAR_K_ETC"));
				bean.setUse_yn	(rs.getString("USE_YN"));
				col.add(bean); 
            }            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 System.out.println("[AddCarMstDatabase:getCarKmList]"+se);
	  		 System.out.println("[AddCarMstDatabase:getCarKmList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarKmBean[])col.toArray(new CarKmBean[0]);
    }
    
    /**
     * 차량연비 수정 
     * date : 20160930
     * author : 성승현
     * from : updateCarDc(CarDcBean bean)
     */
    public int updateCarKm(CarKmBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE CAR_KM SET"+
				" ENGINE		=?, "+
				" CAR_K		=?, "+
				" CAR_K_ETC		=?, "+
				" CAR_K_DT		=replace(?,'-',''), "+
				" USE_YN			=? "+
				" WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_K_DT=? AND CAR_K_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);            
			pstmt.setString	 (1, bean.getEngine		().trim());
			pstmt.setString   (2, bean.getCar_k		().trim());
			pstmt.setString 	(3, bean.getCar_k_etc	().trim());
			pstmt.setString   (4, bean.getCar_k_dt		().trim());
			pstmt.setString 	(5, bean.getUse_yn	().trim());
            pstmt.setString	(6,bean.getCar_comp_id	().trim());
            pstmt.setString	(7,bean.getCar_cd		().trim());
            pstmt.setString	(8,bean.getCar_k_dt	().trim());
            pstmt.setString	(9,bean.getCar_k_seq	().trim());
            count = pstmt.executeUpdate();   
         
            pstmt.close();          
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:updateCarkm]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
     * 차량연비 삭제 
     * date : 20161006
     * author : 성승현
     * from : deleteCarDc(CarDcBean bean)
     */
    public int deleteCarKm(CarKmBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM CAR_KM WHERE CAR_COMP_ID=? AND CAR_CD=? AND CAR_K_DT=? AND CAR_K_SEQ=?\n";
           
       try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);     
            pstmt.setString(1, bean.getCar_comp_id().trim());						
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_k_dt().trim());
			pstmt.setString(4, bean.getCar_k_seq().trim());
            count = pstmt.executeUpdate();   
           
            pstmt.close();          
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AddCarMstDatabase:deleteCarKm]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    //차량 기본사양 가져오기(2018.01.26)
    public Vector getCarBaseList(String car_comp_id, String code, String car_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD, "+
				"  		 a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION, "+
				" 		 c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.CAR_B_INC_ID, c.CAR_B_INC_SEQ "+
				"   FROM car_mng a, code b, car_nm c, "+
				"   	 (select car_comp_id, car_cd, car_id, max(car_seq) car_seq from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id) d "+
				"   where a.car_comp_id=c.car_comp_id and a.code=c.car_cd "+
				"     and a.car_comp_id=b.code and b.c_st = '0001' "+
				"     and c.car_comp_id=d.car_comp_id(+) and c.car_cd=d.car_cd(+) and c.car_id=d.car_id(+) and c.car_seq=d.car_seq(+) "+
				"     and c.use_yn='Y' "+
				"     and c.est_yn='Y' "+
				"     and c.car_b_dt>='20040101' " ;
		
		if(!car_comp_id.equals("")){	query += " and a.car_comp_id = '" + car_comp_id + "' ";		}
		if(!code.equals("")){			query += " and a.code = '" 		  + code + "' ";			}
		if(!car_id.equals("")){			query += " and c.car_id = '"	  + car_id +"' ";			}
		query += "order by car_nm, car_name, c.car_b_p" ;
		
		try {
		    pstmt = con.prepareStatement(query);
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
		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarBaseList]"+e);
			System.out.println("[AddCarMstDatabase:getCarBaseList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
    
    //차량 기본사양 가져오기(2020.05.27)
    public Vector getCarBaseList2(String car_comp_id, String code, String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException
    {
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	Vector vt = new Vector();
    	String query = "";
    	
    	query = " SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD, "+
    			"  		 a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION, "+
    			" 		 c.CAR_SEQ, c.CAR_B, c.CAR_B_P, c.CAR_B_DT, c.CAR_B_INC_ID, c.CAR_B_INC_SEQ "+
    			"   FROM car_mng a, code b, car_nm c, "+
    			"   	 (select car_comp_id, car_cd, car_id, max(car_seq) car_seq from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id) d "+
    			"   where a.car_comp_id=c.car_comp_id and a.code=c.car_cd "+
    			"     and a.car_comp_id=b.code and b.c_st = '0001' "+
    			"     and c.car_comp_id=d.car_comp_id(+) and c.car_cd=d.car_cd(+) and c.car_id=d.car_id(+) and c.car_seq=d.car_seq(+) "+
    			"     and c.use_yn='Y' "+
    			"     and c.est_yn='Y' "+
    			"     and c.car_b_dt>='20040101' " ;
    	
    	if(!car_comp_id.equals("")){	query += " and a.car_comp_id = '" + car_comp_id + "' ";		}
    	if(!code.equals("")){			query += " and a.code = '" 		  + code + "' ";			}
    	if(!car_id.equals("")){			query += " and c.car_id = '"	  + car_id +"' ";			}
    	if(!car_seq.equals("")){			query += " and c.car_seq = '"	  + car_seq +"' ";			}
    	query += "order by car_nm, car_name, c.car_b_p" ;
    	
    	try {
    		pstmt = con.prepareStatement(query);
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
    	} catch (SQLException e) {
    		System.out.println("[AddCarMstDatabase:getCarBaseList]"+e);
    		System.out.println("[AddCarMstDatabase:getCarBaseList]"+query);
    		e.printStackTrace();
    	} finally {
    		try{
    			if(rs != null ) rs.close();
    			if(pstmt != null) pstmt.close();
    		}catch(SQLException _ignored){}
    		connMgr.freeConnection(DATA_SOURCE, con);
    		con = null;
    	}
    	return vt;
    }
    
    //차량 선택사양 가져오기(2018.01.26) -- 정렬수정(2018.06.15)
    public Vector getCarOptionList(String car_comp_id, String code, String car_id) throws DatabaseException, DataSourceEmptyException
	{	
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//query = " SELECT a.car_s_seq as id, a.car_u_seq as seq, a.car_s as nm, a.car_s_p as amt, '' s_st, '' car_b, a.opt_b, a.JG_OPT_ST, a.JG_TUIX_ST, a.car_rank "+
				//"  	FROM car_opt a, (select car_comp_id, car_cd, car_id, max(car_u_seq) car_u_seq from car_opt group by car_comp_id, car_cd, car_id) b "+
		query = " SELECT a.car_s_seq as id, a.car_u_seq as seq, a.car_s as nm, a.car_s_p as amt, '' s_st, '' car_b, a.opt_b, a.JG_OPT_ST, a.JG_TUIX_ST, a.LKAS_YN, a.LDWS_YN, a.AEB_YN, a.FCW_YN, a.HOOK_YN, a.CAR_RANK, a.JG_OPT_YN, b.duty_free_opt " +
				"  	FROM car_opt a, "+
				"  	(select car_comp_id, car_cd, car_id, hp_yn, car_seq, duty_free_opt from car_nm WHERE use_yn='Y') b  "+
				"   WHERE a.car_comp_id=b.car_comp_id "+
				"     AND a.car_cd=b.car_cd and a.car_id=b.car_id "+
				//"     AND a.car_u_seq=b.car_u_seq "+
				"     AND a.car_u_seq=b.car_seq "+
				"     AND a.car_s_dt>='20040101' "+
				"     AND USE_YN = 'Y' " ;
		
		if(!car_comp_id.equals("")){	query += " AND a.car_comp_id = '" + car_comp_id + "' ";		}
		if(!code.equals("")){			query += " AND a.car_cd = '" 	  + code + "' ";			}
		if(!car_id.equals("")){			query += " AND a.car_id = '"	  + car_id +"' ";			}
		query += "ORDER BY TO_NUMBER(car_rank) ASC" ;
		
		try {
		    pstmt = con.prepareStatement(query);
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
		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarOptionList]"+e);
			System.out.println("[AddCarMstDatabase:getCarOptionList]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
    
    //차량 선택사양 가져오기(2018.01.26) -- 정렬수정(2018.06.15)
    public Vector getCarOptionList2(String car_comp_id, String code, String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException
    {	
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	Vector vt = new Vector();
    	String query = "";
    	
    	//query = " SELECT a.car_s_seq as id, a.car_u_seq as seq, a.car_s as nm, a.car_s_p as amt, '' s_st, '' car_b, a.opt_b, a.JG_OPT_ST, a.JG_TUIX_ST, a.car_rank "+
    	//"  	FROM car_opt a, (select car_comp_id, car_cd, car_id, max(car_u_seq) car_u_seq from car_opt group by car_comp_id, car_cd, car_id) b "+
    	query = " SELECT a.car_s_seq as id, a.car_u_seq as seq, a.car_s as nm, a.car_s_p as amt, '' s_st, '' car_b, a.opt_b, a.JG_OPT_ST, a.JG_TUIX_ST, a.LKAS_YN, a.LDWS_YN, a.AEB_YN, a.FCW_YN, a.HOOK_YN, a.CAR_RANK, a.JG_OPT_YN, b.duty_free_opt " +
    			"  	FROM car_opt a, "+
    			"  	(select car_comp_id, car_cd, car_id, hp_yn, car_seq, duty_free_opt from car_nm WHERE use_yn='Y') b  "+
    			"   WHERE a.car_comp_id=b.car_comp_id "+
    			"     AND a.car_cd=b.car_cd and a.car_id=b.car_id "+
    			//"     AND a.car_u_seq=b.car_u_seq "+
    			"     AND a.car_u_seq=b.car_seq "+
    			"     AND a.car_s_dt>='20040101' "+
    			"     AND USE_YN = 'Y' " ;
    	
    	if(!car_comp_id.equals("")){	query += " AND a.car_comp_id = '" + car_comp_id + "' ";		}
    	if(!code.equals("")){			query += " AND a.car_cd = '" 	  + code + "' ";			}
    	if(!car_id.equals("")){			query += " AND a.car_id = '"	  + car_id +"' ";			}
    	if(!car_seq.equals("")){			query += " AND a.car_u_seq = '"	  + car_seq +"' ";			}
    	query += "ORDER BY TO_NUMBER(car_rank) ASC" ;
    	
    	try {
    		pstmt = con.prepareStatement(query);
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
    	} catch (SQLException e) {
    		System.out.println("[AddCarMstDatabase:getCarOptionList]"+e);
    		System.out.println("[AddCarMstDatabase:getCarOptionList]"+query);
    		e.printStackTrace();
    	} finally {
    		try{
    			if(rs != null ) rs.close();
    			if(pstmt != null) pstmt.close();
    		}catch(SQLException _ignored){}
    		connMgr.freeConnection(DATA_SOURCE, con);
    		con = null;
    	}
    	return vt;
    }
    
    //상위사양 가져오기
    public Hashtable getUpperTrim(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement stmt = null;
        ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
        
        query = " SELECT CAR_NAME, CAR_B, CAR_B_INC_ID, CAR_B_INC_SEQ "+
				"   FROM CAR_NM "+
				"	WHERE CAR_ID = '" + car_id + "'" +
				"	  AND CAR_SEQ = '" + car_seq + "'";
		try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();
            if(rs.next()){
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getUpperTrim]"+se);
			System.out.println("[AddCarMstDatabase:getUpperTrim]"+query);
			 throw new DatabaseException(query);
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
	}
    		
    public Vector getCarColExcelList() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";

        
        query = " SELECT * FROM   car_col ";
	
		query += " ORDER BY car_comp_id, car_cd, NVL(col_st,'1'), car_c_dt, to_number(car_c_seq) ";

		//System.out.println("col : "+query);
        Collection<CarColBean> col = new ArrayList<CarColBean>();

        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            ResultSetMetaData rsmd = rs.getMetaData();
            
            while(rs.next()){
            	Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	 
            }
            
            rs.close();
            stmt.close();


        }catch(SQLException se){
			System.out.println("[AddCarMstDatabase:getCarColList]"+se);
			System.out.println("[AddCarMstDatabase:getCarColList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
}
