<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.res_search.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn" class="acar.secondhand.SecondhandBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//차량정보
	Hashtable res = rs_db.getCarInfo(car_mng_id);
	
	//재리스예약현황
	Vector srh = shDb.getShResHList(car_mng_id);
	int srh_size = srh.size();
	
	//보유차등록현황
	Vector conts = rs_db.getResCarList(car_mng_id);
	int cont_size = conts.size();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>[<%=res.get("CAR_NO")%>] 차량예약 이력</span></span></td>
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
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="5%">연번</td>				
                    <td class="title" width="10%">담당자</td>
                    <td class="title" width="10%">진행상황</td>					
                    <td class="title" width="20%">예약기간</td>					
                    <td class="title" width="45%">메모</td>
                    <td class="title" width="10%">등록일</td>					
                </tr>
				<%	
					for(int i = 0 ; i < srh_size ; i++){
						Hashtable sr_ht = (Hashtable)srh.elementAt(i);
						%>
                <tr> 
                    <td align="center"><%=i+1%></td>				
                    <td align="center"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>
                    <td align="center"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("상담중");
        									else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))	out.print("계약확정");  %></td>
                    <td align="center">
					<%if(String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
					대기<%//= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %>
					<%}else{%>
					<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
					<%}%>
					</td>
                    <td>&nbsp;<%=sr_ht.get("MEMO")%></td>
                    <td align="center">
					<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %>
					</td>					
                </tr>
				<%}%>
            </table>
	    </td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보유차운행현황</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="5%">연번</td>
                    <td class=title width="8%">담당자</td>					
                    <td class=title width="8%">구분</td>
                    <td class=title width="6%">상태</td>
                    <td class=title width="33%">대여기간</td>
                    <td class=title width="20%">상호</td>
                    <td class=title width="10%">계약자</td>
                    <td class=title width="10%">등록일자</td>
                </tr>
              <%	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=reservs.get("BUS_NM")%></td>					
                    <td align="center"><span title='<%=reservs.get("RENT_S_CD")%>'><%=reservs.get("RENT_ST")%></span></td>
                    <td align="center"><%=reservs.get("USE_ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%> ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%></td>
                    <td align="center"><%=reservs.get("FIRM_NM")%></td>
                    <td align="center"><%=reservs.get("CUST_NM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(reservs.get("REG_DT")))%></td>
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
        <td align="right" colspan=2><a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	    </td>	
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
