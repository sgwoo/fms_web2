/**
 * 차종
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_mst;

import java.util.*;
import java.sql.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

public class CarMstDatabase {

    private static CarMstDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized CarMstDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarMstDatabase();
        return instance;
    }
    
    private CarMstDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	/**
     * 자동차회사 영업소
     */
    private CarMstBean makeCarMstBean(ResultSet results, String kd) throws DatabaseException {

        try {
            CarMstBean bean = new CarMstBean();
            
            if(kd.equals("jg_code")){
				bean.setCar_comp_id(results.getString("CAR_COMP_ID"));					//자동차회사ID
				bean.setCode(results.getString("CODE"));
				bean.setCar_cd(results.getString("CAR_CD"));
				bean.setCar_nm(results.getString("CAR_NM"));
				bean.setJg_code(results.getString("JG_CODE"));
			} else{
			    bean.setCar_comp_id(results.getString("CAR_COMP_ID"));					//자동차회사ID
			    bean.setCar_comp_nm(results.getString("CAR_COMP_NM"));					//자동차회사이름
			    bean.setCode(results.getString("CODE"));
			    bean.setCar_cd(results.getString("CAR_CD"));
			    bean.setCar_nm(results.getString("CAR_NM"));
				if(kd.equals("nm"))
			    {
					bean.setCar_id(results.getString("CAR_ID"));
					bean.setCar_name(results.getString("CAR_NAME"));			
				}
				if(kd.equals("kind"))
			    {
					bean.setSd_amt(results.getInt("SD_AMT"));			
					bean.setEst_yn(results.getString("EST_YN"));			
					bean.setMain_yn(results.getString("MAIN_YN"));			
					bean.setAb_nm(results.getString("AB_NM"));			
				}
				bean.setCar_yn(results.getString("CAR_YN"));
				bean.setSection(results.getString("SECTION"));
				bean.setDlv_ext(results.getString("DLV_EXT"));
			}
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 차종 조회.
     */
    public CarMstBean [] getCarKindAll(String car_comp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.car_comp_id, b.nm as CAR_COMP_NM, a.code, a.car_cd, a.car_nm, a.use_yn as CAR_YN, a.SECTION, a.SD_AMT, a.EST_YN, a.main_yn, a.ab_nm, a.dlv_ext \n"
				+ "FROM car_mng a, code b\n"
				+ "where a.car_comp_id like '%" + car_comp_id + "%'\n"
				+ "and a.car_comp_id=b.code\n"
				+ "and b.c_st = '0001' order by a.use_yn desc, a.car_nm, a.est_yn desc \n";

        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarMstBean(rs,"kind"));
 
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
     * 차종 조회.
     */
    public CarMstBean [] getCarKindAll_Esti(String car_comp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.car_comp_id, b.nm as CAR_COMP_NM, a.code, a.car_cd, a.car_nm, a.use_yn as CAR_YN, a.SECTION, a.SD_AMT, a.EST_YN, a.main_yn, a.ab_nm, a.dlv_ext \n"
				+ "FROM car_mng a, code b\n"
				+ "where a.car_comp_id like '%" + car_comp_id + "%'\n"
				+ "and a.car_comp_id=b.code\n"
				+ "and b.c_st = '0001' and nvl(a.est_yn,'Y')='Y' order by a.car_nm\n";

        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarMstBean(rs,"kind"));
 
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
     * 차종 조회.
     */
    public CarMstBean [] getCarKindAll_Main(String car_comp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.car_comp_id, b.nm as CAR_COMP_NM, a.code, a.car_cd, a.car_nm, a.use_yn as CAR_YN, a.SECTION, a.SD_AMT, a.EST_YN, a.main_yn, a.ab_nm, a.dlv_ext \n"
				+ "FROM car_mng a, code b\n"
				+ "where a.car_comp_id like '%" + car_comp_id + "%'\n"
				+ "and a.car_comp_id=b.code\n"
				+ "and b.c_st = '0001' and nvl(a.main_yn,'Y')='Y' order by a.car_nm\n";

        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarMstBean(rs,"kind"));
 
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
        
        query = "SELECT a.car_comp_id as CAR_COMP_ID, b.nm as CAR_COMP_NM, a.code as CODE, a.car_cd as CAR_CD,"+
				" a.car_nm as CAR_NM, c.car_id as CAR_ID,c.car_name as CAR_NAME, c.use_yn as CAR_YN, c.SECTION, a.dlv_ext \n"
				+ "FROM car_mng a, code b, car_nm c\n"
				+ "where a.car_comp_id = '" + car_comp_id + "'\n"
				+ "and a.code = '" + code + "'\n"
				+ "and a.car_comp_id=c.car_comp_id\n"
				+ "and a.code=c.car_cd\n"
				+ "and a.car_comp_id=b.code\n"
				+ "and b.c_st = '0001' order by b.nm\n";

        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCarMstBean(rs,"nm"));
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
	 *	차종리스트
	 *  args -  com_id : 자동차회사ID
	 */
	public Vector getCarKindList(String car_comp_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select CODE, CAR_CD, CAR_NM, USE_YN as CAR_YN from CAR_MNG where car_comp_id = '" + car_comp_id + "' ORDER BY CAR_NM ";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
     * 차종 등록.
     */
    public int insertCarKind(CarMstBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="INSERT INTO CAR_MNG(CAR_COMP_ID,\n"
								+ "CODE,\n"
								+ "CAR_CD,\n"
								+ "CAR_NM,USE_YN,SD_AMT,EST_YN,main_yn,AB_NM,dlv_ext)\n"
       //  + "SELECT ?,nvl(lpad(max(TO_NUMBER(CODE))+1,3,'0'),'001'),UPPER(?),?,?,?,?,?\n"
            + "SELECT ?,"
            + "DECODE(LENGTH(MAX(TO_NUMBER(CODE))+1),'3',nvl(lpad(max(TO_NUMBER(CODE))+1,3,'0'),'001'),nvl(lpad(max(TO_NUMBER(CODE))+1,2,'0'),'01')),"
            + "UPPER(?),?,?,?,?,?,?,?\n"
            
            + "FROM CAR_MNG\n"
            + "WHERE CAR_COMP_ID=? "
			+ " ";
			
		//if(bean.getCar_comp_id().equals("0001"))	query += " and code between '30' and '50'"; //29,70 남음 
		//if(bean.getCar_comp_id().equals("0002"))	query += " and code between '10' and '29'"; //10-29 소진시 35-46으로 할것
            
       try{
            con.setAutoCommit(false);       
            
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id().trim());
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_nm().trim());
            pstmt.setString(4, bean.getCar_yn().trim());
            pstmt.setInt   (5, bean.getSd_amt());
            pstmt.setString(6, bean.getEst_yn().trim());
            pstmt.setString(7, bean.getMain_yn().trim());
			pstmt.setString(8, bean.getAb_nm().trim());           
			pstmt.setString(9, bean.getDlv_ext().trim());
			pstmt.setString(10, bean.getCar_comp_id().trim());           
            count = pstmt.executeUpdate();
                     
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
				System.out.println("[CarMStDatabase:insertCarKind]"+se);
				System.out.println("[CarMStDatabase:insertCarKind]"+query);
				insertCarKindRe(bean);
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
     * 차종 등록.
     */
    public int insertCarKindRe(CarMstBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="INSERT INTO CAR_MNG(CAR_COMP_ID,\n"
								+ "CODE,\n"
								+ "CAR_CD,\n"
								+ "CAR_NM,USE_YN,SD_AMT,EST_YN,main_yn)\n"
       //	+ "SELECT ?,nvl(lpad(max(TO_NUMBER(CODE))+1,3,'0'),'001'),UPPER(?),?,?,?,?,?\n"
	        + "SELECT ?,"
	        + "DECODE(LENGTH(MAX(TO_NUMBER(CODE))+1),'3',nvl(lpad(max(TO_NUMBER(CODE))+1,3,'0'),'001'),nvl(lpad(max(TO_NUMBER(CODE))+1,2,'0'),'01')),"
	        + "UPPER(?),?,?,?,?,?\n"					
            + "FROM CAR_MNG\n"
            + "WHERE CAR_COMP_ID=? "
			+ " ";
			
		//if(bean.getCar_comp_id().equals("0001"))	query += " and code between '28' and '29'"; //29,70 남음 
		//if(bean.getCar_comp_id().equals("0002"))	query += " and code between '35' and '46'"; //10-29 소진시 35-46으로 할것
            
       try{
            con.setAutoCommit(false);       
            
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id().trim());
            pstmt.setString(2, bean.getCar_cd().trim());
            pstmt.setString(3, bean.getCar_nm().trim());
            pstmt.setString(4, bean.getCar_yn().trim());
            pstmt.setInt   (5, bean.getSd_amt());
            pstmt.setString(6, bean.getEst_yn().trim());
            pstmt.setString(7, bean.getMain_yn().trim());
			pstmt.setString(8, bean.getCar_comp_id().trim());           
            count = pstmt.executeUpdate();
                     
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
				System.out.println("[CarMStDatabase:insertCarKind]"+se);
				System.out.println("[CarMStDatabase:insertCarKind]"+query);
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
     * 차명 등록.
     */
    public int insertCarNm(CarMstBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="INSERT INTO CAR_NM(CAR_COMP_ID,\n"
								+ "CAR_ID,\n"
								+ "CAR_CD,\n"
								+ "CAR_NAME,USE_YN)\n"
            + "SELECT ?,nvl(lpad(max(CAR_ID)+1,6,'0'),'000001'),?,?,?\n"
            + "FROM CAR_NM\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_comp_id().trim());
            pstmt.setString(2, bean.getCode().trim());
            pstmt.setString(3, bean.getCar_name().trim());
            pstmt.setString(4, bean.getCar_yn().trim());           
            count = pstmt.executeUpdate();
            
           
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
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
     * 차종 수정
     */
    public int updateCarKind(CarMstBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query=" UPDATE CAR_MNG SET CAR_CD=?,CAR_NM=?,USE_YN=?,SD_AMT=?,EST_YN=?,MAIN_YN=?,AB_NM=?,DLV_EXT=? \n"
            + " WHERE CAR_COMP_ID=? AND CODE=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getCar_cd().trim());
            pstmt.setString(2, bean.getCar_nm().trim());
            pstmt.setString(3, bean.getCar_yn().trim());
            pstmt.setInt   (4, bean.getSd_amt());
            pstmt.setString(5, bean.getEst_yn().trim());
            pstmt.setString(6, bean.getMain_yn().trim());
            pstmt.setString(7, bean.getAb_nm().trim());
            pstmt.setString(8, bean.getDlv_ext().trim());
            pstmt.setString(9, bean.getCar_comp_id().trim());
            pstmt.setString(10, bean.getCode().trim());
            count = pstmt.executeUpdate();
            
         
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
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
    public int updateCarNm(CarMstBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE CAR_NM SET CAR_NAME=?, USE_YN=?\n"
            + "WHERE CAR_ID=? AND CAR_COMP_ID=? AND CAR_CD=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getCar_name().trim());
            pstmt.setString(2, bean.getCar_yn().trim());
            pstmt.setString(3, bean.getCar_id().trim());
            pstmt.setString(4, bean.getCar_comp_id().trim());
            pstmt.setString(5, bean.getCode().trim());
            count = pstmt.executeUpdate();
            
            
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
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
     * 차명 차종분류코드 연결 수정.
     */
    public int updateCarNmLink(CarMstBean bean, String sec_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        String query1 = "";
        String query2 = "";
		String query = "";
        int count = 0;
                
		//차명관리 수정-한건
        query1 = " UPDATE CAR_NM SET SECTION='"+bean.getSection().trim()+"'\n"
			  + "WHERE CAR_ID='"+bean.getCar_id().trim()+"'"+
				" AND CAR_COMP_ID='"+bean.getCar_comp_id().trim()+"'"+
				" AND CAR_CD='"+bean.getCode().trim()+"'\n";

		//차명관리 수정-전체
        query2 = " UPDATE CAR_NM SET SECTION='"+bean.getSection().trim()+"'\n"
            + "WHERE CAR_COMP_ID='"+bean.getCar_comp_id().trim()+"' and CAR_CD='"+bean.getCode().trim()+"'\n";

		//차종관리 수정
        query = " UPDATE CAR_MNG SET SECTION='"+bean.getSection().trim()+"', SEC_ST='"+sec_st+"'\n"
            + "WHERE CAR_COMP_ID='"+bean.getCar_comp_id().trim()+"' AND CODE='"+bean.getCode().trim()+"'\n";		   

       try{
            con.setAutoCommit(false);

			if(sec_st.equals("")){

				pstmt1 = con.prepareStatement(query1);            
			    count = pstmt1.executeUpdate();				
				pstmt1.close();

			}else{//"A"

				pstmt1 = con.prepareStatement(query);            
			    count = pstmt1.executeUpdate();	
				pstmt1.close();
				
	            pstmt2 = con.prepareStatement(query2);            
			    count = pstmt2.executeUpdate();				
	            pstmt2.close();
			}
            
            con.commit();
			count = 1;

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
	 *	차명 한건조회
	 */
	public String getCarNm(String car_comp_id, String code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_cd = "";
		String query = "";


		query = " select car_nm from car_mng where car_comp_id='"+car_comp_id+"' AND code='"+code+"'";
		
		try {
		    pstmt = con.prepareStatement(query);
            //pstmt.setString(1, car_comp_nm);
           // pstmt.setString(2, car_nm);
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
	 *	차명 한건조회
	 */
	public String getCarAbNm(String car_comp_id, String code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_cd = "";
		String query = "";

		query = " select nvl(ab_nm,car_nm) car_nm from car_mng where car_comp_id='"+car_comp_id+"' AND code='"+code+"'";
		
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			
			if(rs.next())
			{				
				car_cd = rs.getString(1);
			}

			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AddCarMstDatabase:getCarAbNm]"+e);
			System.out.println("[AddCarMstDatabase:getCarAbNm]"+query);
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
     * 차종 단건 + 차종코드 조회.
     */
    public CarMstBean[] getCarKind(String car_comp_id, int car_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		
		CarMstBean bean = new CarMstBean();
		
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT distinct a.car_comp_id, a.code, a.car_cd, a.car_nm, b.jg_code "
        		+ " FROM car_mng a, car_nm b "
        		+ " WHERE a.car_comp_id = b.car_comp_id AND a.code = b.car_cd "
        		+ " AND a.car_comp_id = " + car_comp_id + " AND a.code = " + car_cd
        		+ " ORDER BY b.jg_code ";
        
        Collection<CarMstBean> col = new ArrayList<CarMstBean>();
        
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCarMstBean(rs,"jg_code"));
 
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

}
