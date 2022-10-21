<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector exps = mc_db.Master_CarList(gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int exp_size = exps.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='allot_size' value='<%=exp_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class=line2 colspan=2></td>
	</tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='49%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='8%' class='title'>연번</td>
					<td width='12%' class='title'>업체</td>
					<td width='12%' class='title'>접수일</td>
					<td width='21%' class='title'>계약번호</td>
					<td width='20%' class='title'>상호</td>
					<td width='15%' class='title'>고객명</td>
					<td width='12%' class='title'>차량번호</td>
				</tr>
			</table>
		</td>
		<td class='line' width='51%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='19%' class='title'>차명</td>
                    <td width='10%' class='title'>담당자</td>
                    <td width='26%' class='title'>서비스항목</td>
                    <td width='10%' class='title'>금액(공급가)</td>
                    <td width='13%' class='title'>지출예정일</td>
                    <td width='13%' class='title'>지출일</td>
                    <td width='9%' class='title'>출금</td>
                </tr>
            </table>
		</td>
	</tr>
<%	if(exp_size > 0){%>
	<tr>
		<td class='line' width='49%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);

				%>
                <tr> 
                    <td width='8%' align='center'><%=i+1%></td>
                    <td width='12%' align='center'>
                    <% if ( String.valueOf(exp.get("GUBUN")).equals("1")  )  {  %>마스타자동차<% } %>
                    <% if ( String.valueOf(exp.get("GUBUN")).equals("5")  )  {  %>삼성애니카랜드<% } %>
                    <% if ( String.valueOf(exp.get("GUBUN")).equals("7")  )  {  %>SK네트웍스<% } %>
                    </td>
                    <td width='12%' align='center'><%=exp.get("LJS_DT")%></td>
<!--                    <td width='20%' align='center'><a href="javascript:parent.view_exp('<%=exp.get("RENT_MNG_ID")%>', '<%=exp.get("RENT_L_CD")%>', '<%=exp.get("CAR_MNG_ID")%>', '<%=auth_rw%>')" onMouseOver="window.status=''; return true"><%=exp.get("RENT_L_CD")%></a></td> -->
                    <td width='21%' align='center'><%=exp.get("RENT_L_CD")%></td>
                    <td width='20%' align='center'><span title='<%=exp.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(exp.get("FIRM_NM")), 7)%></span></td>
                    <td width='15%' align='center'><span title='<%=exp.get("GGM")%>'><%=Util.subData(String.valueOf(exp.get("GGM")), 4)%></span></td>
                    <td width='12%' align='center'><a href="javascript:parent.view_car('<%=exp.get("RENT_MNG_ID")%>', '<%=exp.get("RENT_L_CD")%>', '<%=exp.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=exp.get("CAR_NO")%></a></td>
                </tr>
                <%}%>
                <tr> 
                    <td colspan=7 class="title">&nbsp;합계</td>
                  		
                </tr>
            </table>
		</td>
		<td class='line' width='51%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < exp_size ; i++){
				Hashtable exp = (Hashtable)exps.elementAt(i);
				
				%>
                <tr> 
                    <td width='19%' align='center'><span title='<%=exp.get("CAR_NM")%>%>'><%=Util.subData(String.valueOf(exp.get("CAR_NM")), 9)%></span></td>
                    <td width='10%' align='center'><%=exp.get("USER_NM")%></td>
                    <td width='26%' align='center'><%=Util.subData(String.valueOf(exp.get("SBSHM")), 10)%></td>
                    <td width='10%' align='right'><%=AddUtil.parseDecimal(exp.get("SBGB_AMT"))%>&nbsp;</td>
                    <td width='13%' align='center'><%=exp.get("LGJYJ_DT")%></td>
                    <td width='13%' align='center'><%=exp.get("LGJ_DT")%></td>
                    <td width='9%' align='center'><%if(exp.get("GJ_DT").equals("")){%>-<%}else{%>지출완료<%}%></td>
                </tr>
<%	total_su = total_su + 1;
				total_amt   = total_amt  + AddUtil.parseLong(String.valueOf(exp.get("SBGB_AMT")));
		  			}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" colspan="2" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			
                </tr>
                
            </table>
        </td>
	<tr>
		<td colspan=""></td>
        <td></td>
    </tr>
<%}else{%>
    <tr>
		<td class='line' width='49%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='51%'>			
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
