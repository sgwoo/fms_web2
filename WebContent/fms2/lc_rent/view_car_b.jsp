<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//상위차량의 기본사양 조회 페이지
	
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 	= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	int v_left 	= request.getParameter("v_left")==null?100:AddUtil.parseInt(request.getParameter("v_left"));
	int v_top 	= request.getParameter("v_top")	==null?100:AddUtil.parseInt(request.getParameter("v_top"));
	
	//자동차회사&차종&자동차명 
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
//	Hashtable car_b = a_cmb.getCar_b(car_id, car_seq);
	
//	String car_b_inc_name = a_cmb.getCar_b_inc_name((String)car_b.get("CAR_B_INC_ID"), (String)car_b.get("CAR_B_INC_SEQ"));	
	
	//자동차기본정보
	CarMstBean cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	//자동차기본정보-기본차량
	CarMstBean cm_bean2 = a_cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	v_left 	= v_left+50;
	v_top 	= v_top +50;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
	.highlight {
	font-size:20px;
	font-weight:bold;
	color:#fff;
	background: #4F56E5;
	border-radius:2px;	
	}
</style>
<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<script language="JavaScript">
<!--
function open_car_b(car_id, car_seq, car_name){
	window.open('view_car_b.jsp?from_page=<%=from_page%>&car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name+'&v_left=<%=v_left%>&v_top=<%=v_top%>', "car_b_<%=v_left%>", "left=<%=v_left%>, top=<%=v_top%>, width=450, height=400, scrollbars=yes"); 
}
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>기본사양</span></span></td>
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
                     <td class="title"><%= car_name %> 기본사양</td> 
                </tr> 
                <tr> 
                    <td align=center>
                        <table width=98% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td style='height:7'></td>
                            </tr>
                            <tr>
                                <td>
								  <%if(!cm_bean2.getCar_name().equals("") && !car_name.equals(cm_bean2.getCar_name())){%>
								  <a href="javascript:open_car_b('<%=cm_bean2.getCar_id()%>','<%=cm_bean2.getCar_seq()%>','<%=cm_bean2.getCar_name()%>')" title='<%=cm_bean2.getCar_name()%> 기본사양 보기'>
								    <font color='#999999'><%=cm_bean2.getCar_name()%>외&nbsp;</font>
								  </a>
								  <%}%>
        			  			  <dlv id="contents"><%=cm_bean.getCar_b()%></dlv>								  
            		            </td> 
            		        </tr>
            		        <tr>
                                <td style='height:5'></td>
                            </tr>
            		   </table>
            	    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--	
<%if(from_page.equals("digital_key")){%>
var search = '디지털';
$("#contents:contains('"+search+"')").each(function (){
	var regex = new RegExp(search, 'gi');
	$(this).html( $(this).text().replace(regex, "<span class='highlight'>"+search+"</span>"));
})
<%}%>
//-->
</script>
</body>
</html>
