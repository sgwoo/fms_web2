<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "acar.util.*, acar.offls_cmplt.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")		==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")		==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")		==null?"":request.getParameter("gubun3");
	String gubun_nm = request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	String dt	= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")		==null?"":request.getParameter("s_au");

	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="javascript">
	function view_detail(car_mng_id, seq)
	{
		var fm = document.form1;
		fm.car_mng_id.value = car_mng_id;
		fm.seq.value = seq;
		fm.target = "d_content";
		fm.action = "/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp";
		fm.submit();
	}
	
	//엑셀 다운 추가  
	function excel_list(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "off_ls_stat_excel_list.jsp?ck_acar_id=<%=ck_acar_id%>";
		fm.submit();
	}	
</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' target='d_content' action='/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'> 
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun_nm' value='<%=gubun_nm%>'>
<input type='hidden' name='dt' value='<%=dt%>'>
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'>
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>
<input type='hidden' name='s_au' value='<%=s_au%>'>
<input type='hidden' name='from_page' value='/acar/off_ls_cmplt/off_ls_stat_sc.jsp'>  
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='seq' value=''>


<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td align=''><a href="javascript:excel_list();"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
    <tr> 
        <td align="right">
            * 평균 예상낙찰가대비율:
              [현대글로비스-시화]	<input type='text' name='avg_per1' size='4' class='whitenum'>%&nbsp;
              [현대글로비스-분당]	<input type='text' name='avg_per2' size='4' class='whitenum'>%&nbsp;
	      [에이제이셀카 주식회사]	<input type='text' name='avg_per4' size='4' class='whitenum'>%&nbsp;		
              [롯데렌탈]		<input type='text' name='avg_per3' size='4' class='whitenum'>%&nbsp;            
        </td>
    </tr>
    <tr>
        <td>			
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td><iframe src="./off_ls_stat_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun=<%=gubun%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun_nm=<%=gubun_nm%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&s_au=<%=s_au%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                </tr>
            </table>
		</td>
    </tr>
    <tr> 
        <td align="right">
            * 예상낙찰가 : 20150512 이전에는 재리스잔존가, 20150512 부터는 예상낙찰가 계산값
        </td>
    </tr>    
</table>
</form>
</body>
</html>