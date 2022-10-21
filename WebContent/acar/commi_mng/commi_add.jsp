<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.commi_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language="JavaScript" src='/include/common.js'></script>
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
	
	function set_amt(obj){
		var fm = document.form1;
		var per = 1;
		if(fm.cust_st.value == '2') 		per = 0.03;
		else if(fm.cust_st.value == '3') 	per = 0.04;		
		if(obj == fm.commi){					
			fm.inc_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.commi.value)) * per )); 
			fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
		}
		fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
		fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) - toInt(parseDigit(fm.tot_amt.value))); 
		fm.sup_dt.focus();
	}
	
	function set_l_cd(m_id, l_cd, car_no, firm_nm){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.car_no.value = car_no;
		fm.firm_nm.value = firm_nm;								
	}
	
	function save(){
		var fm = document.form1;
		if(fm.m_id.value == ''){ alert('해당 차량번호를 선택하십시오'); return; }
		if(fm.l_cd.value == ''){ alert('해당 차량번호를 선택하십시오'); return; }		
		if(confirm('등록하시겠습니까?')){
			var fm = document.form1;
			fm.target='i_no';
			fm.action='/acar/commi_mng/commi_add_a.jsp';			
			fm.submit();
		}
	}
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String cust_st = request.getParameter("a_cust_st")==null?"":request.getParameter("a_cust_st");
	
	Vector commis = ac_db.getCommis(emp_id);
	int commi_size = commis.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='emp_id' value='<%=emp_id%>'>
<input type='hidden' name='cust_st' value='<%=cust_st%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
  <!--
	<tr id='tr_title' style='position:relative;z-index:1'>
	  <td class='line' width='490' id='td_title' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width='490'>
        </table>
	  </td>
	</tr>-->
	<tr> 
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=5% class=title>연번</td>
                    <td width=15% class=title>계약번호</td>
                    <td width=20% class=title>계약자</td>
                    <td width=15% class=title>출고일자</td>
                    <td width=15% class=title>차량번호</td>
                    <td width=30% class=title>차종</td>
                </tr>
          <%if(commi_size > 0){%>
          <%for(int i = 0 ; i < commi_size ; i++){
			CommiBean commi = (CommiBean)commis.elementAt(i);%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=commi.getRent_l_cd()%></td>
                    <td align='center'><span title='<%=commi.getFirm_nm()%>'><%=Util.subData(commi.getFirm_nm(), 15)%></span></td>
                    <td  align='center'><%=commi.getDlv_dt()%></td>
                    <td  align='center'><a href="javascript:set_l_cd('<%=commi.getRent_mng_id()%>','<%=commi.getRent_l_cd()%>','<%=commi.getCar_no()%>','<%=commi.getFirm_nm()%>');"><%=commi.getCar_no()%></a></td>
                    <td align='center'><span title='<%=commi.getCar_nm()+" "+commi.getCar_name()%>'><%=Util.subData(commi.getCar_nm()+" "+commi.getCar_name(), 20)%></span></td>
                </tr>
          <%}%>
          <%}else{%>
                <tr> 
                    <td colspan="6" align='center'>등록된 데이타가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
	</tr>
	<tr>
	    <td>&nbsp; </td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대리점수당</span></td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr>
	<tr>
	    <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=15% class=title>계약자</td>
                    <td width=22% >&nbsp;<input type='text' name='firm_nm' class='whitetext' size='40' readonly></td>
                    <td width=15% class=title>차량번호</td>
                    <td width=48%>&nbsp;<input type='text' name='car_no' class='whitetext' size='30' readonly></td>
                </tr>
                <tr> 
                    <td class=title>지급수수료</td>
                    <td colspan="3" >&nbsp;<input type='text' name='commi' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>세금</td>
                    <td colspan="3" >&nbsp;<input type='text' name='tot_amt' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원 (근로소득세 <input type='text' name='inc_amt' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
        			  원 주민세 <input type='text' name='res_amt' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원)</td>
                </tr>
                <tr> 
                    <td class=title>지급금액</td>
                    <td colspan="3" >&nbsp;<input type='text' name='dif_amt' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>지급일자</td>
                    <td colspan="3" >&nbsp;<input type='text' name='sup_dt' class='text' size='12' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      </td>
                </tr>
            </table> 
	    </td>
	</tr>
	<tr>
	    <td align="right"><a href="javascript:save()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
</table>
</form>
</body>
</html>
