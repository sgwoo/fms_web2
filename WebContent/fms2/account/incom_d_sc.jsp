<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String s_kd2 	= request.getParameter("s_kd2")==null? "":request.getParameter("s_kd2");
	String t_wd2 	= request.getParameter("t_wd2")==null? "" :request.getParameter("t_wd2");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String bank_nm 	= request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
	String bank_no 	= request.getParameter("bank_no")==null?"" :request.getParameter("bank_no");
	//조회용
	String bank_code 	= request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	String card_cd 		= request.getParameter("card_cd")==null?"":request.getParameter("card_cd");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"15":request.getParameter("s_cnt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?card_cd="+card_cd+"&bank_code="+bank_code+"&s_cnt=15&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&bank_nm="+bank_nm+"&bank_no="+bank_no+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&s_kd2="+s_kd2+"&t_wd2="+t_wd2+"&andor="+andor+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+"&gubun2="+gubun2+"&from_page="+from_page+
				   	"&sh_height="+height+"";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
 	//계약서 내용 보기
	function view_incom(incom_dt, incom_seq, jung_st, incom_amt, ip_method, p_gubun) {
		var fm = document.form1;
		
		fm.incom_dt.value = incom_dt;
		fm.incom_seq.value = incom_seq;
		fm.jung_st.value = jung_st;
		fm.incom_amt.value = incom_amt;
		fm.ip_method.value = ip_method;
		
		fm.target ='d_content';
		
		if (jung_st == 'CMS' ) {
			fm.action = 'incom_c.jsp'; //조회
		} else if (jung_st == '가수금' )   {
			fm.action = 'incom_reg_step2.jsp'; //정산입력
		} else if (jung_st == '대기' )   {
			fm.action = 'incom_reg_step2.jsp'; //정산입력
		} else if (jung_st == '카드사입금대기' )   {
			fm.action = 'incom_reg_card_step2.jsp'; //정산입력	
		} else if (jung_st == '보험해지입금대기' )   {
			fm.action = 'incom_reg_ins_step2.jsp'; //정산입력			
		} else {
			fm.action = 'incom_c.jsp'; //조회
		}
		
		fm.submit();
	}
	
	function view_incom_cms(incom_dt, incom_seq, jung_st, incom_amt, ip_method, p_gubun) {
		var fm = document.form1;
		
		fm.incom_dt.value = incom_dt;
		fm.incom_seq.value = incom_seq;
		fm.jung_st.value = jung_st;
		fm.incom_amt.value = incom_amt;
		fm.ip_method.value = ip_method;
		
		fm.target ='d_content';
		
		if (jung_st == 'CMS' ) {	
		//	fm.action = 'incom_c.jsp'; //조회
			fm.action = 'incom_reg_cms_step.jsp'; //조회
		}
		
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>		
  <input type='hidden' name='s_kd2'  	value='<%=s_kd2%>'>
  <input type='hidden' name='t_wd2' 	value='<%=t_wd2%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='dt' 	value='<%=dt%>'>  
  <input type='hidden' name='ref_dt1' 	value='<%=ref_dt1%>'>  
  <input type='hidden' name='ref_dt2' 	value='<%=ref_dt2%>'>  
  <input type='hidden' name='from_page' value='/fms2/account/incom_d_frame.jsp'>  
  <input type='hidden' name='gubun' value=''>
  <input type='hidden' name='incom_dt' value=''>
  <input type='hidden' name='incom_seq' value=''> 
  <input type='hidden' name='jung_st' value=''>  
  <input type='hidden' name='incom_amt' value=''> 
  <input type='hidden' name='s_cnt' value='15'> 
  <input type='hidden' name='v_gubun' value='N'> 
  <input type='hidden' name='ip_method' value=''>  
    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span></td>
	</tr>
	<tr>
	    <td>
    		<table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
        			<td>
        			  <iframe src="incom_d_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
        			</td>
    		    </tr>
    		</table>
	    </td>
	</tr>
</table>
</form>
</body>
</html>
