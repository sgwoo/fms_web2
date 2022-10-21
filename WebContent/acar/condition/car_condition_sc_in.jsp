<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.con_car.*"%>
<jsp:useBean id="c_db" scope="page" class="acar.con_car.CarDatabase"/>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String ins_com = request.getParameter("ins_com")==null?"":request.getParameter("ins_com");

	CarBean[] cars = c_db.getCar(s_kd, t_wd);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
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
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding='0' width='1620'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td id='td_title' class=line style='position:relative;' width=25%> 
            <table border=0 cellspacing=1 cellpadding=0 width='100%'>
                <tr>
                    <td width='12%' class='title'>연번</td>
                    <td width='25%' class='title'>&nbsp;<br/>계약번호<br/>&nbsp;</td>
                    <td width='40%' class='title'>상호</td>
                    <td width='23%' class='title'>차량번호</td>
        	    </tr>
            </table>
		</td>		
        <td class='line' width=75%> 
            <table border=0 cellspacing=1 cellpadding=0 width="100%" >
                <tr> 
                    <td class='title' width="8%">&nbsp;<br/>등록일<br/>&nbsp;</td>
                    <td class='title' width="9%">차명</td>
                    <td class='title' width="7%">대여개월수</td>
                    <td class='title' width="8%">월대여료</td>
                    <td class='title' width="8%">할부금잔액</td>
                    <td class='title' width="8%">할부금융사</td>
                    <td class='title' width="8%">대여개시일</td>
                    <td class='title' width="8%">대여만료일</td>
                    <td class='title' width="5%">연장여부</td>
                    <td class='title' width="8%">선납금</td>
                    <td class='title' width="8%">개시대여료</td>
                    <td class='title' width="8%">보증금</td>
                    <td class='title' width="7%">영업담당자</td>
                </tr>
            </table>
        </td>
    </tr>
<%
	if(cars.length > 0)
	{
%>
	<tr>
		
        <td id='td_con' class=line style='position:relative;' width=25%> 
            <table border=0 cellspacing=1 cellpadding='0' width='100%'>
        <%
		for(int i = 0 ; i < cars.length ; i++)
		{
			CarBean car = cars[i];
%>
                <tr>
		            <td width='12%' align='center'><%=i+1%></td>            		
                    <td width='25%' align='center'><%=car.getRent_l_cd()%></td>            		
                    <td width='40%' align='left'><span title='<%=car.getClient_nm()%>'>&nbsp;&nbsp;<%=AddUtil.subData(car.getClient_nm(),10)%></span></td>            		
                    <td width='23%' align='center'><%=car.getCar_no()%></td>
            	</tr>
<%		}
%>
            </table>
        </td>
		
        <td class=line> 
            <table border=0 cellspacing=1 cellpadding='0' width='100%' width=75%>
        <%
		for(int i = 0 ; i < cars.length ; i++)
		{
			CarBean car = cars[i];
%>
                <tr> 
                    <td align='center' width="8%"><%=AddUtil.ChangeDate2(car.getInit_reg_dt())%></td>
                    <td align='center' width="9%"><%=AddUtil.subData(car.getCar_nm(),6)%></td>
                    <td width='7%' align='center'><%=car.getCon_mon()%></td>
                    <td width='8%' align='right'><%=AddUtil.parseDecimal(car.getFee_mon())%>&nbsp;</td>
                    <td width='8%' align='right'><%=AddUtil.parseDecimal(car.getAllot_jan())%>&nbsp;</td>
                    <td width='8%' align='center'><%=car.getAllot_bank()%></td>
                    <td width='8%' align='center'><%=AddUtil.ChangeDate2(car.getRent_start_dt())%></td>
                    <td width='8%' align='center'><%=AddUtil.ChangeDate2(car.getRent_end_dt())%></td>
                    <td width='5%' align='center'><%=car.getRent_st()%></td>
                    <td width='8%' align='right'><%=AddUtil.parseDecimal(car.getPp_amt())%>&nbsp;</td>
                    <td width='8%' align='right'><%=AddUtil.parseDecimal(car.getIfee_amt())%>&nbsp;</td>
                    <td align='right' width="8%"><%=AddUtil.parseDecimal(car.getGrt_amt())%>&nbsp;</td>
                    <td align='center' width="7%"><%=car.getBus_nm()%></td>
                </tr>
        <%
		}
%>
            </table>
        </td>
    </tr>
<%
	}
	else
	{
%>
    <tr>		
        <td id='td_con' class=line style='position:relative;' width=25%> 
            <table border=0 cellspacing=1 cellpadding='0' width='100%'>
                <tr>					
                    <td align='center'>&nbsp;</td>
				</tr>
			</table>
		</td>		
        <td width=75% class='line'> 
            <table border=0 cellspacing=1 cellpadding='0' width='100%'>
                <tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>		
	</tr>
<%
	}
%>
</table>
</body>
</html>