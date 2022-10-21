<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.mng_exp.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt = 0;
	
	
	
	Vector exps = ex_db.getExpList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int exp_size = exps.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='allot_size' value='<%=exp_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class=line2 colspan=2></td>
	</tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='40%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='11%' class='title'>연번</td>
					<td width='27%' class='title'>계약번호</td>
					<td width='39%' class='title'>상호</td>
					<td width='23%' class='title'>차량번호</td>
				</tr>
			</table>
		</td>
		<td class='line' width='60%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='29%' class='title'>차명</td>
                    <td width='24%' class='title'>지출구분</td>
                    <td width='17%' class='title'>금액</td>
                    <td width='15%' class='title'>지출예정일자</td>
                    <td width='15%' class='title'>지출일자</td>
                    <!--<td width='10%' class='title'>출금</td>-->
                </tr>
            </table>
		</td>
	</tr>
<%	if(exp_size > 0){%>
	<tr>
		<td class='line' width='40%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);
				%>
                <tr> 
                    <td width='11%' align='center'><%=i+1%></td>
                    <td width='27%' align='center'><a href="javascript:parent.view_exp('<%=exp.get("RENT_MNG_ID")%>', '<%=exp.get("RENT_L_CD")%>', '<%=exp.get("CAR_MNG_ID")%>', '<%=exp.get("EXP_ST")%>', '<%=exp.get("EST_DT")%>', '<%=auth_rw%>')" onMouseOver="window.status=''; return true"><%=exp.get("RENT_L_CD")%></a></td>
                    <td width='39%' align='center'><span title='<%=exp.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(exp.get("FIRM_NM")), 9)%></span></td>
                    <td width='23%' align='center'><a href="javascript:parent.view_car('<%=exp.get("RENT_MNG_ID")%>', '<%=exp.get("RENT_L_CD")%>', '<%=exp.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=exp.get("CAR_NO")%></a></td>
                </tr>
                <%}%>
                <tr> 
                    <td class="title"></td>		  
                    <td class="title">&nbsp;</td>
                    <td class="title">합계</td>			
                    <td class="title">&nbsp;</td>			
                </tr>
            </table>
		</td>
		<td class='line' width='60%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);%>
                <tr> 
                    <td width='29%' align='center'><span title='<%=exp.get("CAR_NM")%> <%=exp.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(exp.get("CAR_NM"))+" "+String.valueOf(exp.get("CAR_NAME")), 13)%></span></td>
                    <td width='24%' align='center'><%=exp.get("GUBUN")%><%if(!String.valueOf(exp.get("MIGR_DT")).equals("")){%><%}%></td>
                    <td width='17%' align='right'><%=Util.parseDecimal(String.valueOf(exp.get("AMT")))%>원&nbsp;</td>
                    <td width='15%' align='center'><%=exp.get("EST_DT")%></td>
                    <td width='15%' align='center'><%=exp.get("PAY_DT")%></td>
                    <!--<td width='10%' align='center'> 
                      <%if(exp.get("PAY_YN").equals("0")){%>
                      <a href="javascript:parent.pay_exp('<%=exp.get("CAR_MNG_ID")%>', '<%=exp.get("EXP_ST")%>', '<%=exp.get("EST_DT")%>', '<%=auth_rw%>', '<%=user_id%>')"><img src=/acar/images/center/button_in_cg.gif border=0 align=absmiddle></a> 
                      <%}else{%>
                      - 
                      <%}%>
                    </td>
                    -->
                </tr>
                <%	total_su = total_su + 1;
				total_amt   = total_amt  + AddUtil.parseLong(String.valueOf(exp.get("AMT")));
		  			}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                </tr>
            </table>
        </td>
<%	}else{%>
    <tr>
		<td class='line' width='40%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='60%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
</body>
</html>
