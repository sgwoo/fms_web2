<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
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
	function view_cont(seq){
		var fm = document.form1;
		fm.seq.value 	= seq;
		fm.target ='d_content';
		fm.action = 'pur_pre_c.jsp';
		fm.submit();
	}
	
 	//엑셀
	function execl(){
		var fm = document.form1;
		fm.target ='_blank';
		fm.action = 'pur_pre_sc_in_excel.jsp';
		fm.submit();
	}		
	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/pur_com_pre/ecar_charg_frame.jsp'>  
  <input type='hidden' name='seq' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
    <!-- <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span></td>
    </tr> -->
    <tr>
	<td>
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		<tr>
        	    <td>
        		<%-- <iframe src="ecar_charg_sc_in.jsp<%=vlaus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe> --%>
        		<iframe src="ecar_charg_sc_in.jsp<%=vlaus%>" name="inner" width="100%" height="550" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 id='sc_in'></iframe>
        	    </td>
    		</tr>
    	    </table>
	</td>
    </tr>
    <tr>
    	<td>
    		<table border="0" cellspacing="0" cellpadding="0" width=100%>
    			<tr>
    				<td>충전기 서류</td>
    				<td>충전기 보조금 신청서</td>
    				<td>전기자동차 충전기 설치 신청서, 현장점검확인서, 유의사항안내, (설치동의서), 계약사실확인서, 렌트계약서, 주민등록등본, 아마존카 사업자사본</td>
    			</tr>
    			<tr>
    				<td>발송 단계</td>
    				<td>완료 서류</td>
    				<td>설치완료신고서, 대여계시후렌트계약서, 설치협약서, 차량등록증, 등록원부(갑)</td>
    			</tr>
    			<tr>
    				<td colspan="2">대영채비 신청 싸이트</td>
    				<td><a href='javascript:window.open("https://www.chaevi.co.kr/Menus/Etc/InstallAccept.aspx");'>https://www.chaevi.co.kr/Menus/Etc/InstallAccept.aspx</a></td>
    			</tr>
    		</table>
    	</td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
