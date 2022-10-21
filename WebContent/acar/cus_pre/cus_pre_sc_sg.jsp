<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	
	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	

%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//검색하기	
function adjust_vst(client_id,seq){
	var SUBWIN="../cus_reg/vst_reg.jsp?client_id=" + client_id + "&seq=" + seq + "&page_nm=cus_pre_sc_gs&user_id=<%= user_id %>";
	window.open(SUBWIN, 'popwin_vst_reg','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50');
}
function go_cus_reg_visit(firm_nm){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=1&t_wd="+firm_nm;
	fm.target = "d_content";
	fm.submit();
}
function go_cus_reg_serv(car_no){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=2&s_kd=2&t_wd="+car_no;
	fm.target = "d_content";
	fm.submit();
}
function go_cus_reg_maint(car_no){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=3&s_kd=2&t_wd="+car_no;
	fm.target = "d_content";
	fm.submit();
}
function serv_apply(rmid,rlcd,irid){
	var fm = document.form1;
	if(!confirm('해당 예약건을 완료 하시겠습니까?')){ return; }	
	fm.target = "i_no";
	fm.action = "../cus0404/serv_apply_ok.jsp?rent_mng_id="+rmid+"&rent_l_cd="+rlcd+"&ires_id="+irid+"&page_nm=cus_pre_sc_gs&user_id=<%= user_id %>";
	fm.submit();
}
	//고객 보기
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
		function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st, idx){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.idx.value = idx;						
		fm.cmd.value = "u";	

		var url = "?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&accid_st="+accid_st+"&idx="+idx;
		var SUBWIN = "/acar/accid_mng/accid_u_frame.jsp" + url;
	//	window.open(SUBWIN, 'AccidentDisp','scrollbars=yes,status=no,resizable=no,width=900,height=700,top=50,left=50');

		fm.action='/acar/accid_mng/accid_u_frame.jsp'
		fm.target = "d_content";
		fm.submit();
	}
	
function next_serv_cng(car_mng_id, serv_id){
	var theForm = document.form1;
	var auth_rw = theForm.auth_rw.value;	
	var url = "?auth_rw=" + auth_rw
			+ "&car_mng_id=" + car_mng_id
			+ "&serv_id=" + serv_id;

	var SUBWIN="/acar/cus_sch/next_serv_cng.jsp" + url;	
	
	window.open(SUBWIN, 'popwin_next_serv_cng','scrollbars=yes,status=no,resizable=no,width=440,height=150,top=200,left=500');
}

//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

function dg_input(number)
{
	var SUBWIN="http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1="+number; //우체국등기조회링크
	window.open(SUBWIN, "dg_input", "left=50, top=50, width=850, height=300, resizable=yes, scrollbars=yes");
}		

function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}
	
function view_email(m_id, l_cd, c_id){
		window.open("http://fms1.amazoncar.co.kr/mailing/ser/insp.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id, "VIEW_EMAIL", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}	

	function serv_action(car_mng_id, serv_id, accid_id){
		var fm = document.form1;
		var SUBWIN="/acar/cus_reg/serv_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id+"&accid_id="+accid_id+"&from_page=/acar/cus_pre/cus_pre_sc_gs.jsp"; 
		window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=720,top=50,left=50');
	}
-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><a name='3'></a></td>
    </tr>  
    		  
    <%
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
//	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
//	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	//if(s_kd.equals("5")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	Hashtable id = c_db.getDamdang_id(user_nm);
	user_id = String.valueOf(id.get("USER_ID"));
	
	Vector accids = as_db.getAccidUList(user_id);
	int accid_size = accids.size();
%>
	<tr> 
		<td><a name='6'></a></td>
	</tr>
	<tr> 
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>진행중인 사고내역 : 총 <font color="#FF0000"><%= accids.size()  %></font>건</span></td>
	</tr>
	<tr>    
		<td class=line2></td>
	</tr>

<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
	<tr> 
		<td class=line> 
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
		<td>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>            
				<tr> 
					<td width='10%' class='title'>연번</td>
					<td width='10%' class='title'>진행상태</td>
					<td width='10%' class='title'>사고구분</td>
					<td width='20%' class='title'>계약번호</td>
					<td width='20%' class='title'>상호</td>
					<td width='15%' class='title'>차량번호</td>
					<td width='15%' class='title'>사고일시</td>
				</tr>
			</table>
		</td>
	</tr>
	<input type='hidden' name='accid_size' value='<%=accid_size%>'>                
<%	if(accid_size > 0){%>
	<tr>
		<td class='line'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<% 		for (int i = 0 ; i < accid_size ; i++){
						Hashtable accid = (Hashtable)accids.elementAt(i);%>
				<tr> 
					<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='10%' align='center'><a name="<%=i+1%>"><%=i+1%> 
						<%if(accid.get("USE_YN").equals("Y")){%>
						<%}else{%>
							(해약)
						<%}%>
						</a>
					</td>
					<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='10%' align='center'> 
						<%if(String.valueOf(accid.get("SETTLE_ST")).equals("1")){%>
							종결 
						<%}else{%>
							<font color="#FF6600">진행</font> 
						<%}%>
					</td>
					<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='10%' align='center'><%=accid.get("ACCID_ST_NM")%></td>
					<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='20%' align='center'><a href="javascript:AccidentDisp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("ACCID_ID")%>', '<%=accid.get("ACCID_ST")%>', '<%=i%>')" onMouseOver="window.status=''; return true"><%=accid.get("RENT_L_CD")%></a></td>
					<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='20%' align='center'> 
						<%if(accid.get("FIRM_NM").equals("(주)아마존카") && !accid.get("CUST_NM").equals("")){%>
						<span title='(<%=accid.get("RES_ST")%>)<%=accid.get("CUST_NM")%>'><%=Util.subData(String.valueOf(accid.get("CUST_NM")), 6)%></span>	
						<%}else{%>
						<span title='<%=accid.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 11)%></span> 
						<%}%>
					</td>
					<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='15%' align='center'><%=accid.get("CAR_NO")%></td>
					<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='15%' align='center'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
				</tr>
				<%	}%>
			</table>
		</td>
	</tr>
	<%	}else{%>                     
	<tr>
		<td class='line'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
	</tr>
	<% 	}%></table>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
