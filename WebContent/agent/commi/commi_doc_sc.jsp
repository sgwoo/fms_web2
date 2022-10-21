<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>

<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-120;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,fileExtensionwinName,features) {
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		if(fileExtension == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		}else{
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+""+fileExtension;
		}						
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();				
	}	
	
	//거래처 보기 
	function view_client(rent_mng_id, rent_l_cd, r_st)
	{
		var SUBWIN= "/agent/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=820, height=700, resizable=yes, scrollbars=yes");
	}
	

	//영업사원보기
	function view_emp(emp_id){
		var fm = document.form1;
		window.open("/agent/car_office/car_office_p_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/commi_pay_s_frame.jsp&cmd=view&emp_id="+emp_id, "VIEW_EMP", "left=50, top=50, width=850, height=600, scrollbars=yes");
	}
	
	function commi_action(chk_cnt, mode, rent_mng_id, rent_l_cd, doc_no){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.doc_no.value 		= doc_no;
			
		if(doc_no == ''){
			if(chk_cnt >0){ alert('지급조건 불충이 '+chk_cnt+'건 있습니다.'); return; }		
			fm.action = 'commi_doc_i.jsp';
		}else{
			fm.action = 'commi_doc_u.jsp';
		}
		
		fm.target = 'd_content';
		fm.submit();
	}
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body leftmargin="15" topmargin=0>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/agent/commi/commi_pay_s_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span></td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="commi_doc_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
	    <td>※ 영업수당문서처리 미등록리스트에 안나오는 계약은 계약관리에서 영업구분을 영업사원으로 입력되었는지 확인하세요.</td>
	</tr>		
</table>
</form>
</body>
</html>
