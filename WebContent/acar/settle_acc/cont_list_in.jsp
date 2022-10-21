<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.cls.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
	<title>Untitled</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">	
<script language='JavaScript' src='/include/common.js'></script>
</head>

<body>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String today = request.getParameter("today")==null?"":request.getParameter("today");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
	//계약리스트
	Vector cont_lists = s_db.getContList(client_id);
	int cont_size = cont_lists.size();
	if(cont_size > 0){
		for (int i = 0 ; i < cont_size ; i++){
			Hashtable cont_list = (Hashtable)cont_lists.elementAt(i);
			String c_mon_day = ac_db.getMonDay((String)cont_list.get("RENT_START_DT"), today);
			String use_yn_nm = (String)cont_list.get("USE_YN_NM");
			String c_mon = "", c_day = "";
			if(!c_mon_day.equals("")){
				c_mon = c_mon_day.substring(0,c_mon_day.indexOf('/'));
				c_day = c_mon_day.substring(c_mon_day.indexOf('/')+1);
			}
%>		  
                <tr> 
                    <td align="center" width=5%><%=i+1%></td>
                    <td align="center" width=12%><a href="javascript:parent.view_cont_case('<%=cont_list.get("RENT_MNG_ID")%>','<%=cont_list.get("RENT_L_CD")%>')"><%=cont_list.get("RENT_L_CD")%></a></td>
                    <td align="center" width=10%><%=cont_list.get("CAR_NO")%></td>
                    <td align="center" width=20%><span title='<%=cont_list.get("CAR_NM")%> <%=cont_list.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(cont_list.get("CAR_NM"))+" "+String.valueOf(cont_list.get("CAR_NAME")), 12)%></span></td>
                    <td align="center" width=15%><%=cont_list.get("RENT_START_DT")%>~<%if(use_yn_nm.equals("대여")){%><%=cont_list.get("RENT_END_DT")%><%}else{%><%=cont_list.get("CLS_DT")%><%}%></td>
                    <td align="center" width=11%><%=c_mon%>개월<%=c_day%>일</td>
                    <td align="center" width=9%><%=cont_list.get("RENT_WAY")%></td>
                    <td align="center" width=9%><%=c_db.getNameById(String.valueOf(cont_list.get("BUS_ID2")), "USER")%></td>
                    <td align="center" width=9%><%=cont_list.get("USE_YN_NM")%>&nbsp;</td>
                </tr>
<%		}
	}else{%>		  
                <tr> 
                    <td align="center" colspan="9">자료가 없습니다.</td>
                </tr>
<%	} %>		  
            </table>
        </td>
    </tr>
</table>
</body>
</html>
