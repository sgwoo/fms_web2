<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_sche.*, acar.schedule.*, acar.car_service.*, acar.esti_mng.*" %>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<jsp:useBean id="EstiMngDb" scope="page" class="acar.esti_mng.EstiMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function AncReg(){
		var SUBWIN="./anc_i.jsp";	
		window.open(SUBWIN, "AncReg", "left=100, top=100, width=520, height=350, scrollbars=no");
	}

	function AncDisp(bbs_id){
		var SUBWIN="./anc_c.jsp?bbs_id=" + bbs_id;	
		window.open(SUBWIN, "AncDisp", "left=100, top=100, width=520, height=350, scrollbars=no");
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?br_id:request.getParameter("s_brch_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_user_id = request.getParameter("s_user_id")==null?"":request.getParameter("s_user_id");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_month = request.getParameter("s_month")==null?"":AddUtil.addZero(request.getParameter("s_month"));
	String s_day = request.getParameter("s_day")==null?"":AddUtil.addZero(request.getParameter("s_day"));
	//String cont = null;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector prvs = aa_db.getUserPrvContent(s_brch_id, s_dept_id,s_user_id, s_year, s_month, s_day);
	int prv_size = prvs.size();
	//업무일지 등록을 안했을경우 거래처방문이나 자동차정비건을 보여주기위해 리스트생성
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	Vector tsls = csd.getTodaySchList(s_user_id, s_year, s_month, s_day);
	
	Vector EstiIngList = EstiMngDb.getEstiListSch(s_user_id, s_year, s_month, s_day);
%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
        		<%if(prv_size > 0  ){
        			for(int i = 0 ; i < prv_size ; i++){
        				Hashtable prv = (Hashtable)prvs.elementAt(i);
        				if(((String)prv.get("DEPT_ID")).equals("9999"))	continue;
        				String cont = AddUtil.replace(String.valueOf(prv.get("CONTENT")),"\\","&#92;&#92;");
        				cont = AddUtil.replace(cont,"\"","&#34;");
        				cont = Util.htmlR(cont);%>
                <tr>
                    <td width=5% align="center"><%=i+1%></td>				
                    <td width=10% align="center" ><%=c_db.getNameById(String.valueOf(prv.get("DEPT_ID")), "DEPT")%></td>
                    <td width=10% align="center"><%=prv.get("USER_NM")%></td>
                    <td width=10% align="center"><%=prv.get("DT")%></td>
                    <td width=65%><a href="javascript:parent.view_content('<%=prv.get("USER_ID")%>','<%=prv.get("SEQ")%>')" onMouseOver="window.status=''; return true">&nbsp;<font color="#990000">[<%=prv.get("SCH_CHK")%>]</font>&nbsp;<%=prv.get("TITLE")%></a></td>
                </tr>
        		<%	}
        			for(int i = 0 ; i < EstiIngList.size() ; i++){
        			Hashtable ht = (Hashtable)EstiIngList.elementAt(i);
        			%>
                <tr>
                    <td align="center"><%=(prv_size+1)+i%></td>				
                    <td align="center"><%=c_db.getNameById("0001", "DEPT")%></td>
                    <td align="center"><%=c_db.getNameById((String)ht.get("MNG_ID"),"USER")%></td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(ht.get("DT"))) %></td>
                    <td><a href="javascript:parent.view_content('<%= ht.get("MNG_ID") %>','0')" onMouseOver="window.status=''; return true">&nbsp;<font color="#990000">[업무일지]</font>&nbsp;</a></td>
                </tr>
        		<%	}
        			for(int i = 0 ; i < tsls.size() ; i++){
        			Hashtable tsl = (Hashtable)tsls.elementAt(i);
        			%>
                <tr>
                    <td align="center"><%=(prv_size+1)+i%></td>				
                    <td align="center" ><%=c_db.getNameById("0002", "DEPT")%></td>
                    <td align="center"><%=c_db.getNameById((String)tsl.get("CHECKER"),"USER")%></td>
                    <td align="center"><%=tsl.get("S_YEAR")%>-<%=tsl.get("S_MONTH")%>-<%=tsl.get("S_DAY")%></td>
                    <td><a href="javascript:parent.view_content('<%=tsl.get("CHECKER")%>','0')" onMouseOver="window.status=''; return true">&nbsp;<font color="#990000">[업무일지]</font>&nbsp;</a></td>
                </tr>
        		<%	}
        		}else{%>
                <tr>
                    <td colspan=5 align=center>등록된 데이타가 없습니다.</td>
                </tr>
        		<%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>