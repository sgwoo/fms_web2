<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.asset.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body style="font-size:12">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
    String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	
	s_month = AddUtil.addZero(s_month);
	
	String work_st 	= request.getParameter("work_st")==null? "":request.getParameter("work_st");
	String s_gubun = request.getParameter("s_gubun")==null?"":request.getParameter("s_gubun");	
	String s_gisu = "";
	String s_flag = "";
	String s_flag4 = "";
	
	int flag = 0;
	int count = 0;
			
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	
	if(work_st.equals("asset_ma_reg")){//--------------------------------------------------------------------------------------------
	
		s_flag =  as_db.call_sp_insert_assetmaster(s_year, s_month, user_id );
			
		System.out.println("자산취득 등록" + s_flag);
		
	//변경 자산 등록
	}else if(work_st.equals("asset_move_reg")){//--------------------------------------------------------------------------------------------
		
		s_flag =  as_db.call_sp_insert_assetmove(s_year, s_month, user_id );
	//	s_flag4 = as_db.call_sp_insert_assetmove4(s_year, user_id );	
		System.out.println("자산변경 등록" + s_flag + " |" + s_flag4);
			
	//매각 자산 등록
	}else if(work_st.equals("asset_move2_reg")){//--------------------------------------------------------------------------------------------
		
		s_flag =  as_db.call_sp_insert_assetmove2(s_year, s_month, user_id );
			
		System.out.println("자산매각 등록" + s_flag);
	
	}else if(work_st.equals("asset_ydep_reg")){//--------------------------------------------------------------------------------------------
		
		s_gisu =  as_db.getMaxgisu();
		System.out.println(s_gisu);
		System.out.println("s_year="+s_year);
		
		if ( s_gisu.equals(s_year) ) {		  
		 s_flag =  as_db.call_sp_insert_yassetdep(s_year, user_id );
		 System.out.println("run");      
		} else {
		 s_flag = "1";  //현재상각중인 기수가 아닌 기수가 이월되면 안됨.
		 System.out.println("err");  
		}
			
		 System.out.println("자산이월 등록" + s_flag);
		
	}else if(work_st.equals("asset_move_chk")){//--------------------------------------------------------------------------------------------
		
		//[1단계] :  변경할 자산 조회
		
		Vector vt = as_db.getAssetNoMoveRegList(s_year, s_month);
		int vt_size = vt.size();
		
		out.println("등록세.매입공채, 취득세 등록 조회 = "+vt_size+"건<br><br><br>");			
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			flag = 0;
			count = 0;
			
			String car_mng_id 	= String.valueOf(ht.get("CAR_MNG_ID"));
			String car_no 	    = String.valueOf(ht.get("CAR_NO"));
			String assch_date 	= String.valueOf(ht.get("ASSCH_DATE"));
			int capamt 	= Util.parseDigit(String.valueOf(ht.get("CAP_AMT")));	//출금액
		 		
		 	//[2단계] : fassetma 테이블에 등록되었는지 조회
		 			
		 	String ma_code = "";
		 	ma_code = as_db.getAsset_info(car_mng_id, car_no, "", "code");	
		
			if ( ma_code.equals("")  || ma_code ==  null  ) { 	
				out.println(i+1+")자동차관리번호="+car_mng_id+", 자동차번호="+ car_no + ", 자산변경금액="+capamt+", 자산변경일="+assch_date+"  확인요!! ");
				out.println("<br>");
		    }
		    
		}	
			
		System.out.println("변경자산 체크" + s_flag);
		
	} else if(work_st.equals("update_assetma")){//--------------------------------------------------------------------------------------------
	

		s_flag =  as_db.call_sp_update_assetmaster(s_year, s_month, s_gubun, user_id );
			
		System.out.println("차량대금 끝전처리" + s_flag);
	} else if(work_st.equals("insert_assetmove_s")){//--------------------------------------------------------------------------------------------
	

		s_flag =  as_db.call_sp_insert_assetmove_s(s_year, s_month, user_id );
			
		System.out.println("특소세처리" + s_flag);	
	} else if(work_st.equals("insert_assetmove_green")){//--------------------------------------------------------------------------------------------
	

		s_flag =  as_db.call_sp_insert_assetmove_green(s_year, s_month, user_id );
			
		System.out.println("구매보조금 처리" + s_flag);		
		
	} else if(work_st.equals("update_assetma_deprf")){//--------------------------------------------------------------------------------------------
	

		s_flag =  as_db.call_sp_update_assetmaster_deprf_yn(s_year, s_month, user_id );
			
		System.out.println("자산취소(deprf_yn=6 처리) " + s_flag);			
		
	} 	
		 
 
%>
<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

</form>
<script language='javascript'>
<%	if(work_st.equals("asset_ma_reg") && !s_flag.equals("0")){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("asset_move_reg") && !s_flag.equals("0")  ){  %>
	  alert("처리되지 않았습니다");
<%	}else if(work_st.equals("asset_move2_reg") && !s_flag.equals("0")){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("asset_ydep_reg") && !s_flag.equals("0")){  %>
		alert("처리되지 않았습니다");
<%	}else if(work_st.equals("update_assetma") && !s_flag.equals("0")){  %>
		alert("처리되지 않았습니다");	
<%	}else if(work_st.equals("insert_assetmove_s") && !s_flag.equals("0")){  %>
		alert("처리되지 않았습니다");		
<%	}else if(work_st.equals("insert_assetmove_green") && !s_flag.equals("0")){  %>
		alert("처리되지 않았습니다");		
<%	}else if(work_st.equals("update_assetma_deprf") && !s_flag.equals("0")){  %>
		alert("처리되지 않았습니다");														
<%	}else{		%>
		alert("처리되었습니다");
<%	}			%>
</script>
</body>
</html>