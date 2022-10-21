<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	String car_comp_id = String.valueOf(reserv.get("CAR_COMP_ID"));
	String car_id = String.valueOf(reserv.get("CAR_ID"));
	String car_year = String.valueOf(reserv.get("CAR_YEAR"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form action="" name="form1" method="post" >
<input type='hidden' name='c_id' value='<%=c_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 영업지원 > 예약관리 > <span class=style5>동급자동차 대여리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>제조사</td>
                    <td align="center" width=16%><%=c_db.getNameById(car_comp_id, "CAR_COM")%><font color="#FFFFCC"><b><font color="#000000"><%//=reserv.get("CAR_NO")%></font></b></font></td>
                    <td class=title width=9%>차명</td>
                    <td align="left" width=46%>&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
                    <td class=title width=9%>연식</td>
                    <td align="center" width=10%><%=car_year%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="4%">연번</td>
                    <td class=title width="11%">차량번호</td>
                    <td class=title width="9%">구분</td>
                    <td class=title width="6%">상태</td>
                    <td class=title width="34%">대여기간</td>
                    <td class=title width="15%">상호</td>
                    <td class=title width="9%">계약자</td>
                    <td class=title width="12%">정상대여료</td>
                </tr>
              <%//동급 예약현황
    			Vector conts = rs_db.getResCarList(car_comp_id, car_id, car_year);
    			int cont_size = conts.size();
    			
    		  	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=reservs.get("CAR_NO")%></td>
                    <td align="center"><%=reservs.get("RENT_ST")%></td>
                    <td align="center"><%=reservs.get("USE_ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%> ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%></td>
                    <td align="center"><%=reservs.get("FIRM_NM")%></td>
                    <td align="center"><%=reservs.get("CUST_NM")%></td>
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(reservs.get("FEE_AMT")))%>&nbsp;원&nbsp;&nbsp;</td>
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='8' align='center'>등록된 데이타가 없습니다</td>
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:self.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>	
</table>
</form>
</body>
</html>
