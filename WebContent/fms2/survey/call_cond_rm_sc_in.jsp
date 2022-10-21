<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.call.*" %>

<%
	PollDatabase p_db = PollDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//사용자ID
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String g_fm = "1";
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	

	String andor 	= request.getParameter("andor")==null?"14":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String dt 	= request.getParameter("dt")==null? "1" :request.getParameter("dt");
	String st_nm 	= request.getParameter("st_nm")==null? "" :request.getParameter("st_nm");

	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	
	Vector vt = p_db.getClsDocCallList(dt, ref_dt1, ref_dt2, s_kd, st_nm, gubun1, andor, "3", user_id);
	
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--

/* Title 고정 */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}


//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

function upd_call( m_id, l_cd)
	{
		var theForm = document.CarRegDispForm;
		
								
		if(confirm('대표통화완료처리 하시겠습니까?'))
		{		
			theForm.target = 'i_no';
			theForm.action = "updateReqCall_a.jsp?m_id="+m_id+"&l_cd="+l_cd;
			theForm.submit();
		}		
	
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
		<td class=line2 colspan="2"></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='5%'  class='title'>연번</td>
		            <td width='10%' class='title'>계약번호</td>
        		    <td width='10%'  class='title'>콜등록일</td>
					<td width='10%' class='title'>계약일</td>
		            <td width="15%" class='title'>고객</td>
				    <td width='10%' class='title'>차량번호</td>		
				    <td width='10%' class='title'>차명</td>	
				    <td width='10%' class='title'>해지일</td>				  		  				  
				    <td width='10%' class='title'>구분</td>
					<td width='10%' class='title'>등록자</td>
				</tr>
			</table>
		</td>
    </tr>
<%	if(vt_size > 0){ %>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td width='5%'  align='center'><%=i+1%></td>
					<td align="center" width='10%'><%if(ht.get("RR_ANSWER").equals("N")){%><%=ht.get("RENT_L_CD")%><%}else{%><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','월렌트','<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%>')">&nbsp;<%=ht.get("RENT_L_CD")%></a><%}%></td>   
					<td width='10%' align='center'><%=ht.get("ANSWER_DATE")%></td>
					<td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
					<td width="15%" align='center'><%=ht.get("FIRM_NM")%></span></td>
					<td width='10%' align='center'><%=ht.get("CAR_NO")%></td>		
					<td width='10%' align='center'><%=ht.get("CAR_NM")%></td>		
					<td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>										
					<td width='10%' align='center'><%=ht.get("CLS_ST_NM")%></td>
					<td width='10%' align='center'><span title="<%=ht.get("CALL_NM")%>"><%=Util.subData(String.valueOf(ht.get("CALL_NM")), 6)%></span></td>
				</tr>
<%}%>
			</table>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
<% }else{%>                     
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(st_nm.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
	</tr>
<% } %>
</table>

<form action="./register_frame.jsp" name="CarRegDispForm" method="POST">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='g_fm' value="1">
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</form>
</body>
</html>