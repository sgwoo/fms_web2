<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"1":request.getParameter("sort");
	String tire_gubun = request.getParameter("tire_gubun")==null?"":request.getParameter("tire_gubun");
	
	String from_page ="";
	if(tire_gubun.equals("000256")){
		from_page="n_tire_reg_off_frame.jsp";
	}
	if(tire_gubun.equals("000148")){
		from_page="/fms2/tire/tire_reg_off_frame.jsp";
	}
	if(tire_gubun.equals("000156")){
		from_page="/fms2/tire/ts_tire_reg_off_frame.jsp";
	}
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-200;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"&tire_gubun="+tire_gubun+"";
					 
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean 	= umd.getUsersBean(user_id);
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function reg_cons(seq, c_id, st, car_no){
		var fm = document.form1;
//		fm.seq.value 		= seq;
		
			fm.target = "d_content";
			if(st == "2"){
				fm.action = "/acar/accid_mng/accid_s_frame.jsp?&car_mng_id="+c_id+"&seq="+seq+"&car_no="+car_no+"&s_kd=3&gubun2=2&gubun3=&t_wd="+car_no+""+"&s_st=3";
			}else {
				fm.action = "/acar/cus_reg/cus_reg_frame.jsp?&car_mng_id="+c_id+"&seq="+seq+"&car_no="+car_no+"&s_kd=3";
			}
			fm.submit();
		
	}
			
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}	
	
	
	
	function view_tire(seq, c_id, l_cd, dtire_yn, cmd){
		var fm = document.form1;
		fm.seq.value 		= seq;
		fm.dtire_yn.value 		= dtire_yn;		
		
		window.open('about:blank', "VIEW_TIRE", "left=10, top=10, width=1024, height=600, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "VIEW_TIRE";
		fm.action = "./tire_reg_off_iu_u.jsp?&seq="+seq+"&c_id="+c_id+"&l_cd="+l_cd+"&cmd="+cmd;
		fm.submit();
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='dtire_yn' value=''>  
   <input type='hidden' name='tire_gubun' value='<%=tire_gubun%>'>  
 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>※ <font color="red"><b>[일반정비] & [재리스정비]</b></font>는 담당자가 직접 담당자확인 버튼을 클릭해서 내용을 확인하고 하단에 <img src="/acar/images/center/button_reg.gif" align="absbottom" border="0">버튼을 클릭하면 자동으로 등록이 됩니다. <br>
		&nbsp;&nbsp;&nbsp;&nbsp;<font color="red"><b>[사고수리]</b></font>는 담당자가 직접 담당자확인 버튼을 클릭해서 내용을 확인하고 사고연결을 한 후에 등록버튼을 눌러주세요.<br>
	</tr>
	<tr>
		<td class=h></td>
	</tr>

	<tr>
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="tire_reg_off_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	
	
</table>
</form>
</body>
</html>
