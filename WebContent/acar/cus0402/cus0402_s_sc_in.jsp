<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cus0402.*" %>
<jsp:useBean id="cnd2" scope="page" class="acar.common.ConditionBean"/>
<jsp:useBean id="c42_scBn" class="acar.cus0402.Cus0402_scBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"22":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");

//System.out.println("st_dt="+st_dt+","+"end_dt="+end_dt);

	cnd2.setGubun1(gubun1);
	cnd2.setGubun2(gubun2);
	cnd2.setGubun3(gubun3);
	//cnd2.setGubun4(gubun4);
	cnd2.setSt_dt(st_dt);
	cnd2.setEnd_dt(end_dt);
	cnd2.setS_kd(s_kd);
	cnd2.setT_wd(t_wd);
	cnd2.setS_bus(s_bus);
	cnd2.setS_brch(s_brch);
	cnd2.setSort_gubun(sort_gubun);
	cnd2.setAsc(asc);
	//cnd2.setIdx(idx);

	Cus0402_Database c42_Db = Cus0402_Database.getInstance();
	Vector clients = c42_Db.getClientList(cnd2);
	int client_size = clients.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}

	function init(){		
		setupEvents();
	}	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width=1450>
	<tr><td class=line2 colspan=2></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='30%' id='td_title' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='13%' class='title'>연번</td>
                    <td width='24%' class='title'>고객구분</td>
                    <td width='39%' class='title'>상호</td>
                    <td width='24%' class='title'>고객명</td>
                </tr>
            </table>
        </td>
		<td class='line' width='70%'>			
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='9%' class='title'>최근방문일</td>
					<td width='9%' class='title'>다음방문일</td>
					<td width='12%' class='title'>전화번호</td>
					<td width='12%' class='title'>휴대폰</td>
					<td width='12%' class='title'>FAX</td>					
					<td width='17%' class='title'>HomePage</td>
					<td width='29%' class='title'>주소</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(client_size > 0){%>
	<tr>
		
        <td class='line' width='30%' id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < client_size ; i++){
    				Hashtable client = (Hashtable)clients.elementAt(i);%>
                <tr> 
                    <td width='13%' align="center"><%=i+1%></td>
                    <td width='24%' align="center"><%=client.get("CLIENT_ST_NM")%></td>
                    <td width='39%'><div align="left">&nbsp;&nbsp;<a href="javascript:parent.view_detail('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(client.get("FIRM_NM")), 10)%></a></div></td>
                    <td width='24%' align="center"><span title='<%=client.get("CLIENT_NM")%>'><%=Util.subData(String.valueOf(client.get("CLIENT_NM")), 6)%></span></td>
                </tr>
            <%} %>
            </table>
        </td>
        <td class='line' width='70%'>			
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			<%for(int i = 0 ; i < client_size ; i++){
				Hashtable client = (Hashtable)clients.elementAt(i);%>
				<tr>
					<td width='9%' align="center"><%=AddUtil.ChangeDate2((String)client.get("VST_DT"))%></td>
					<td width='9%' align="center"><%=AddUtil.ChangeDate2((String)client.get("VST_EST_DT"))%></td>					
					<td width='12%' align="center"><%=client.get("O_TEL")%></td>					
					<td width='12%' align="center"><%=client.get("M_TEL")%></td>					
					<td width='12%' align="center"><%=client.get("FAX")%></td>					
					<td width='17%'>&nbsp;<span title='<%=client.get("HOMEPAGE")%>'><a href='<%=client.get("../mng_client/HOMEPAGE")%>' target='about:blank'><%=Util.subData(String.valueOf(client.get("HOMEPAGE")), 16)%></a></span></td>
					<td width='29%'>&nbsp;<span title='<%=client.get("O_ADDR")%>'><%=Util.subData(String.valueOf(client.get("O_ADDR")), 25)%></span></td>
				</tr>
			<%} %>
			</table>
		</td>
	</tr>	
<%	}else{%>
	<tr>
		
        <td class='line' width='30%' id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
        </td>
		<td class='line' width='70%'>			
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	} %>
</table>
</body>
</html>
