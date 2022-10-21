<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, tax.*, acar.user_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
String su 	= request.getParameter("su")==null?"":request.getParameter("su");
String msg 	= request.getParameter("msg")==null?"":request.getParameter("msg");
String gubun 	= request.getParameter("s_destphone")==null?"":request.getParameter("s_destphone");

String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
String sendphone	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
String destphone	= "";
String msglen 		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");

String msg2 ="";

	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

if(gubun.equals("시화")){
	gubun = "시화-글로비스";
}else if(gubun.equals("분당")){
	gubun = "분당-글로비스";
}else if(gubun.equals("010-9026-1853")){
	gubun = "에이제이셀카(주)";
}
	
if ( destphone.equals("")){

  UsersBean target_bean1 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
  UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장부관리"));
  
				
	msg2 = gubun +" 경매장으로 보내는 탁송차량 리스트 입니다. "+msg;
	
	String rqdate = "";
	
	if(msg_subject.equals("")) msg_subject = "총무팀-김태우차장";
	
	//알림톡
	String auction_name = gubun;										// 경매장 이름
	String car_num_name_arr = msg;									// 출품예정차량
	String car_num_name_arr_count = su;							// 출품예정차량 대수
	String auction_date = AddUtil.getDate();				// 출품일자
		
		
	List<String> fieldList = Arrays.asList(auction_name, car_num_name_arr, car_num_name_arr_count, auction_date, sendname, sendphone);
	at_db.sendMessageReserve("acar0107", fieldList, target_bean1.getUser_m_tel(),  sendphone, null , target_bean1.getUser_nm(),  ck_acar_id);
	
		
	at_db.sendMessageReserve("acar0107", fieldList, target_bean2.getUser_m_tel(),  sendphone, null , target_bean2.getUser_nm(),  ck_acar_id);
	
}

UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
UsersBean udt_mng_bean_s2 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리대체자"));
UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산지점장"));
UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전지점장"));
UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("대구지점장"));
UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("광주지점장"));

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body onLoad="javascript:print(document)" style="margin: 0px 8px;">
<form name='form1' method='post'>

<table table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td align="center"><a href="javascript:print(document)"><img src=/acar/images/button_print.gif border=0></a></td>
	</tr>
	<tr>
		<td class="h"></td>
	</tr>
	<%if(gubun.equals("")){%>
	<tr>
		<td><img src=/acar/images/center/glovis.jpg border=0 align=absmiddle>[본 양식은 현대ㆍ기아자동차경매장 출품용 양식입니다.]</td>
	</tr>
	<%}%>
	<tr>
        <td colspan="2" class=line2></td>
    </tr>
	<tr>
		<td colspan="2" class='line' width=100%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
				  <td class='title' colspan="4" rowspan="1"><font size="6">탁 송 신 청 서</font></td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="3" width="12%">고 객 정 보<br>(실제차량<br>인계자)</td>
				  <td class='title' colspan="2" rowspan="1">고객명</td>
				  <td align="center"><input type='text' size='30' name='' value='(주)아마존카' maxlength='100' class='text' style = "border : none;font:11pt 굴림"></td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="2" width="12%">담당자</td>
				  <td class='title' width="15%">담당자 1</td>
				  <td align="center"><input type='text' size='30' name='' value='<%=udt_mng_bean_s.getUser_nm()%> : <%=udt_mng_bean_s.getHot_tel()%>' maxlength='100' class='text' style = "border : none;font:11pt 굴림"></td>
				</tr>
				<tr>
				  <td class='title' width="15%">담당자 2</td>
				  <td align="center"><input type='text' size='30' name='' value='<%=udt_mng_bean_s2.getUser_nm()%> : <%=udt_mng_bean_s2.getHot_tel()%>' maxlength='100' class='text' style = "border : none;font:11pt 굴림"></td>
				</tr>
				<tr>
				  <td class='title' colspan="4" rowspan="1" align="left">※고객정보는 실제 차량을 전달하시는 분의 정보를 기재하여 주십시요</td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="2">차량정보</td>
				  <td class='title'>차종명</td>
				  <td colspan="2" rowspan="2" align="center"><br><textarea name='msg' rows='16' cols='55' class='text' style='IME-MODE: active; overflow:hidden; border:none; font:11pt 굴림;'><%=msg%></textarea></td>
				</tr>
				<tr>
				  <td class='title'>차량번호</td>
				</tr>
				<tr>
				  <td colspan="2" rowspan="1"class='title' >약도</td>
				  <td colspan="2" rowspan="1" align="center">총 <%=su%>대</td>
				</tr>
				<tr>
				  <td colspan="4" rowspan="1">
				  	<!-- <img src=/acar/images/center/yd.jpg align=absmiddle border=0 width=500 height=450> -->
				  	<img src=/acar/images/center/map_s_youngnam.jpg align=absmiddle border=0 width=500 height=450>
				  </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='h'></td>
	</tr>
<%if(gubun.equals("")){%>	
	<tr>
		<td>※ 탁송료 입금시 입금계좌 및 연락처(입금후 반드시 연락을 해서 확인을 해야합니다.)<br>
		※ 입 금 계 좌 : 외환(05) 174-18-35675-8(예금주:박대희)<br>
		☎ 탁 송 업 체 : 031)766-7217, 031)760-5397 (담당:윤종호 부장님) F:031-766-6131<br>
		☎ 반 출 담 당 : 031)760-5360~61 031)760-5356~57 (담당:공명숙氏, 최희정氏)<br>
		</td>
	</tr>
	<!-- <tr>
		<td>※ 탁송료 입금시 입금계좌 및 연락처(입금후 반드시 연락을 해서 확인을 해야합니다.)</td>
	</tr>
	<tr>
		<td >※ 입 금 계 좌 : 외환(05) 174-18-35675-8(예금주:박대희)</td>
	</tr>
	<tr>
		<td >☎ 탁 송 업 체 : 031)766-7217, 031)760-5397 (담당:윤종호 부장님) F:031-766-6131</td>
	</tr>
	<tr>
		<td >☎ 반 출 담 당 : 031)760-5360~61 031)760-5356~57 (담당:공명숙氏, 최희정氏)</td>
	</tr> -->
<%}%>	
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--


//-->
</script>
</body>
</html>
