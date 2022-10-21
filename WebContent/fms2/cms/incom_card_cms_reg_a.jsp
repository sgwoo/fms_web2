<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	//System.out.println("user_id=" + user_id);	
	
	//cms card  incom 데이타 생성 -  카드는 통장에서 확인불가 승인번호처리 집금처리해야 함.
	String adate 	= request.getParameter("adate")==null?"":request.getParameter("adate");//승인의뢰일자	  
//	String r_adate 	= ad_db.getValidDt(adate); //결과처리일은 승인의뢰일 다음날이다. 공휴일체크

//	String incom_dt 	= request.getParameter("incom_dt")==null?"": request.getParameter("incom_dt") ;
   String incom_dt = adate;
	incom_dt = AddUtil.replace(incom_dt, "-", "");
	
//	long  incom_amt 		= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	String ama_id 	= request.getParameter("ama_id")==null?"":request.getParameter("ama_id"); //기관코드 	
//	String v_gubun 	= request.getParameter("v_gubun")==null?"N":request.getParameter("v_gubun");
			
	int chkdtflag = 0;
	String s_flag = "";
	
	//cms집금처리

	if(adate.equals(incom_dt) ) {  //같다면

		System.out.println("card adate = " + adate);
//		System.out.println("r_adate = " + r_adate);
		System.out.println("incom_dt = " + incom_dt);
	//	System.out.println("incom_amt = " + incom_amt);
	//	System.out.println("v_gubun = " + v_gubun);
	//	
		//신규생성				
		// call procedure
	//	s_flag = "0";	
		s_flag =   ad_db.call_sp_incom_card_cms_magam(adate,  user_id, incom_dt,  ama_id );
		System.out.println("card cms입금처리 등록 " + s_flag);			
	
	} else { //의뢰일+1 가 cms 통장 입금일임 (차이가 있다면 cms 처리 불가 )
	 	chkdtflag = 1;
	} 
	    
%>
<form name='form1' action='/fms2/cms/incom_card_cms_reg.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>
<script language='javascript'>

<%  if(chkdtflag == 1){%>
		alert('통장입금일 입력 오류!');
				
<%	} else if(!s_flag.equals("0") ){%>
		alert('CMS 처리 오류발생!');		
		
<%	}else{%>
		alert('처리되었습니다');
<%	}%>

</script>
</body>
</html>