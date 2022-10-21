<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.user_mng.*, acar.util.*"%>
<%@ page import="acar.cus0401.*" %>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function view_detail(car_mng_id,rent_mng_id,rent_l_cd)
{
	var fm = document.form1;
	var url = "?car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
	var url2 = "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>";
	parent.location.href = "cus0401_d_sc_carinfo.jsp"+url+url2;
}
function view_client(client_id,cmd)
{
	var fm = document.form1;
	var url = "?client_id="+client_id+"&cmd="+cmd;
	var url2 = "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>";
	parent.location.href = "/acar/cus0402/cus0402_d_sc_clientinfo.jsp"+url+url2;
}

//정산수정 - 회차 및 정산일
function view_jungsan(car_mng_id, serv_id)
{
		window.open("/acar/cus_samt/cus_jungsan_popup.jsp?auth_rw=<%=auth_rw%>&car_mng_id="+car_mng_id+"&serv_id="+serv_id, "jungsan", "left=150, top=150, width=400, height=300");
}
	
function list_move(gubun1, gubun2, gubun3)
{
		var fm = document.form1;
		var url = "/acar/cus0401/cus0401_s_frame.jsp?gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3;
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
}

//리스트 엑셀 전환

function pop_excel(s_year, s_mon, s_kd, t_wd){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_excel_service.jsp?s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_kd=" + s_kd+ "&t_wd=" + t_wd;
	fm.submit();
}	

function make_jungsan(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "cus_samt_jungsan.jsp";
		fm.submit();
}	



//청구서작성
	function make_chunggu(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("청구할 대상을 선택하세요.");
			return;
		}	
		
		if(!confirm('해당건을  결재청구하시겠습니까?')){	return;	}
			
//		fm.target = "i_no";
		fm.target = "d_content";
		fm.action = "cus_samt_n_req_a.jsp";
		fm.submit();	
	}		

	
	
//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='s_year' value='<%=s_year%>'>
  <input type='hidden' name='s_mon' value='<%=s_mon%>'>
  <input type='hidden' name='sort' value='<%=sort%>'>
  <input type='hidden' name='asc' value='<%=asc%>'>
  <input type='hidden' name='acct' value='<%=acct%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  

<table width="100%" border="0" cellspacing="1" cellpadding="0">
  <tr>
	<td align='right' width=100%'>&nbsp;&nbsp
<!--	&nbsp;<a href="javascript:make_jungsan();"><img src=../images/center/button_js.gif align=absmiddle border=0></a> -->
    <!--<input type="button" name="excel3" value="Excel" onClick="javascript:pop_excel('<%=s_year%>', '<%=s_mon%>', '<%=s_kd%>', '<%=t_wd%>');" size="14">-->
    <% if(  nm_db.getWorkAuthUser("전산팀",user_id) ||  nm_db.getWorkAuthUser("정비청구",user_id) ) { %>
    &nbsp;<a href="javascript:make_chunggu();"><img src=../images/center/button_chg.gif align=absmiddle border=0></a>
    <% } %>
	</td>
  </tr>	
  <tr> 
    <td><iframe src="./cus_samt_n_sc_in.jsp?height=<%=height%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&acct=<%=acct%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&sh_height=<%=sh_height%>" name="inner" width="100%" height="<%=height+10%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr> 
    <td>&nbsp;<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe></td>
  </tr>

</table>
</form>
</body>
</html>
