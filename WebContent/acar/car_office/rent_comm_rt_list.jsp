<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String s_dt 		= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 		= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");

	String dlv_st 		= request.getParameter("dlv_st")	==null?"":request.getParameter("dlv_st");
	String car_st 		= request.getParameter("car_st")	==null?"":request.getParameter("car_st");
	String bus_st 		= request.getParameter("bus_st")	==null?"":request.getParameter("bus_st");
	String comm_rt 		= request.getParameter("comm_rt")	==null?"":request.getParameter("comm_rt");
	String comm_r_rt 	= request.getParameter("comm_r_rt")	==null?"":request.getParameter("comm_r_rt");
	
	String jg_b_dt = e_db.getVar_b_dt("jg", AddUtil.getDate(4));
	
	Vector vt = new Vector();
	int vt_size = 0;	
	
	
	vt = cod.getRentCommRtCont_2019(bus_st, dlv_st, car_st, comm_r_rt, gubun1, gubun2, s_dt, e_dt, jg_b_dt);
	vt_size = vt.size();			
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > 영업수당수수료현황 > <span class=style5>계약건수</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr>
                    <td width=3% class=title>연번</td>
                    <td width=7% class=title>계약일</td>
                    <td width=12% class=title>상호</td>
                    <td width=8% class=title>차량번호</td>
                    <td width=12% class=title>차명</td>
                    <td width=6% class=title>차종별<br>수수료율</td>                    
                    <td width=6% class=title>최초<br>영업자</td>
                    <td width=8% class=title>영업구분</td>
                    <td width=10% class=title>영업영업소</td>                    
                    <td width=6% class=title>정상<br>수수료율</td>
                    <td width=6% class=title>계약<br>수수료율</td>
                    <td width=8% class=title>영업수당</td>
                    <td width=8% class=title>지급일자</td>
                </tr>
		<%
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);					
		%>
                <tr>
                    <td align=center><%= i+1 %></td>
                    <td align=center><%=ht.get("RENT_DT")%></td>
                    <td align=center><%=ht.get("FIRM_NM")%><br><%=ht.get("RENT_L_CD")%></td>
                    <td align=center><%=ht.get("CAR_NO")%></td>
                    <td align=center><%=ht.get("CAR_NM")%></td>
                    <td align=center><%=ht.get("JG_FG")%></td>                    
                    <td align=center><%=ht.get("BUS_NM")%></td>
                    <td align=center><%=ht.get("BUS_ST_NM")%></td>
                    <td align=center><%=ht.get("CAR_OFF_NM")%><br><%=ht.get("EMP_NM")%></td>                    
                    <td align=center><%=ht.get("COMM_RT")%></td>
                    <td align=center><%=ht.get("COMM_R_RT")%><%if(!String.valueOf(ht.get("CH_REMARK")).equals("")){%><br>(<%=ht.get("CH_REMARK")%>)<%}%></td>
                    <td align=right><%=ht.get("COMMI")%>원<%if(!String.valueOf(ht.get("DLV_CON_COMMI")).equals("0")){%><br>(<%=ht.get("DLV_CON_COMMI")%>원)<%}%></td>
                    <td align=center><%=ht.get("SUP_DT")%></td>
                </tr>
        	<%	}%>        
            </table>
        </td>
    </tr>
    <tr>
        <td align="right"><a href="javascript:window.close()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</body>
</html>

