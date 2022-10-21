<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");

	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
	
		int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	
	if(st_year.equals("")) st_year = ""+s_year;
	if(st_mon.equals("")) st_mon = ""+s_month;
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-550;//현황 라인수만큼 제한 아이프레임 사이즈
	int height1 = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-400;//현황 라인수만큼 제한 아이프레임 사이즈
		
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&st_mon="+st_mon+"&st_year="+st_year+
				   	"&sh_height="+height+"";
					
		
	//노트북 사용자	
	if ( height < 100)  {
		height =100;
	}
	
	if ( height1  <200)  {
		height1 =200;
	}
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function Over_time_Reg(){
		var SUBWIN="./over_time_i.jsp?auth_rw=<%=auth_rw%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";	
		window.open(SUBWIN, "Over_time_Reg", "left=100, top=50, width=1035, height=800, scrollbars=yes");
	}

//엑셀 다운 추가 // 20090727
	function excel_list(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "excel_list.jsp?ck_acar_id=<%=ck_acar_id%>&st_mon=<%=st_mon%>&st_year=<%=st_year%>";
		fm.submit();
	}		
 	//특근신청 내용 보기
	function view_cont(user_id, doc_no){
		var fm = document.form1;
		fm.user_id.value = user_id;
		fm.doc_no.value = doc_no;
		fm.target ='d_content';
		fm.action = 'over_time_c.jsp';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="user_id" value="">
<input type="hidden" name="doc_no" value="">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   	

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>특근신청 미결재 리스트</span></td>
		<td align='right'>
			<a href='javascript:Over_time_Reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;
		</td>
	</tr>
	<tr>
	    <td colspan=2>
	        <table width=100% border=0 cellspacing=0 cellpadding=0>
	            <tr>
                    <td class=line2></td>
                </tr>
	            <tR>	                
                    <td class=line>
            	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                              <td class='title' width='5%'>&nbsp;연번</td>
                              <td class='title' width='7%'>사전보고</td>
                              <td class='title' width='7%'>소속</td>
                              <td class='title' width='8%'>신청인</td>
                              <td class='title' width='7%'>부서</td>
                              <td class='title' width='10%'>귀속년월</td>
                              <td class='title' width='15%'>출근시간</td>
                              <td class='title' width='15%'>퇴근시간</td>
                              <td class='title' width='10%'>근무시간</td>
                              <td class='title' width='9%'>근로시간</td>
                              <td class='title' width='7%'>결재여부</td>		  
                            </tr>
            			</table>
            			<!-- <td width="16">&nbsp;</td> -->
            		</td>
                </tr>
            </table>
        </td>
	</tr>
	<tr>
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="over_time_sc_in.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="h"></td>
	</tr>
  	<tr>
		<td ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>특근신청 결재완료 리스트</span></td>
		<td align='right'>
			<a href="javascript:excel_list();"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;		
		</td>
	</tr>
	<tr>
	    <td colspan=2>
	        <table width=100% border=0 cellspacing=0 cellpadding=0>
	            <tr>
                    <td class=line2></td>
                </tr>
	            <tR>	             
                    <td class=line>
            	        <table border=0 cellspacing=1 width=100%>
                            <tr> 
                              <td class='title' width='5%'>연번</td>
                              <td class='title' width='7%'>사전보고</td>
                              <td class='title' width='7%'>소속</td>
                              <td class='title' width='8%'>신청인</td>
                              <td class='title' width='7%'>부서</td>
                              <td class='title' width='10%'>귀속년월</td>
                              <td class='title' width='15%'>출근시간</td>
                              <td class='title' width='15%'>퇴근시간</td>
                              <td class='title' width='10%'>근무시간</td>
                              <td class='title' width='9%'>근로시간</td>
                              <td class='title' width='7%'>결재여부</td>		  		  
                            </tr>
            			</table>
            			<!-- <td width="16">&nbsp;</td> -->
                	</td>
                </tr>
            </table>
        </td>
	</tr>
	<tr>
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="over_time_sc_in2.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="inner" width="100%" height="<%=height1%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=auto, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
  </tr>
</table>

</form>
</body>
</html>