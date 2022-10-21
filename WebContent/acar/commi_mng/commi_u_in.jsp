<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.commi_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String cust_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	
	Vector commis = ac_db.getCommis(emp_id);
	int commi_size = commis.size();
	
	LoginBean login = LoginBean.getInstance();	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "03");
%>

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
	
	function set_amt(idx, obj){
		return;
		var fm = document.form1;
		var per = 1;
		if(fm.cust_st.value != ''){
			if(fm.cust_st.value == '2') 		per = 0.03;
			else if(fm.cust_st.value == '3') 	per = 0.04;		
			if(fm.commi_size.value == '1'){
				if(obj == fm.commi){					
					fm.inc_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.commi.value)) * per )); 
					fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
				}
				fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
				fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) - toInt(parseDigit(fm.tot_amt.value))); 
				fm.sup_dt.focus();
			}else{
				if(obj == fm.commi[idx]){	
					fm.inc_amt[idx].value = parseDecimal(th_rnd(toInt(parseDigit(fm.commi[idx].value)) * per )); 
					fm.res_amt[idx].value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt[idx].value)) * 0.1 ));						
				}
				fm.tot_amt[idx].value = parseDecimal(toInt(parseDigit(fm.inc_amt[idx].value)) + toInt(parseDigit(fm.res_amt[idx].value))); 
				fm.dif_amt[idx].value = parseDecimal(toInt(parseDigit(fm.commi[idx].value)) - toInt(parseDigit(fm.tot_amt[idx].value))); 
				fm.sup_dt[idx].focus();			
			}
		}else{
			if(fm.commi_size.value == '1'){		
				fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
				fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
				fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) - toInt(parseDigit(fm.tot_amt.value))); 						
			}else{
				fm.res_amt[idx].value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt[idx].value)) * 0.1 )); 			
				fm.tot_amt[idx].value = parseDecimal(toInt(parseDigit(fm.inc_amt[idx].value)) + toInt(parseDigit(fm.res_amt[idx].value))); 
				fm.dif_amt[idx].value = parseDecimal(toInt(parseDigit(fm.commi[idx].value)) - toInt(parseDigit(fm.tot_amt[idx].value))); 						
			}			
		}
	}
	
	function commi_doc(rent_mng_id, rent_l_cd, doc_no){
		var fm = document.form1;
		if(doc_no == ''){
			window.open("/fms2/commi/commi_doc_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_c_c_fee.jsp&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&doc_no="+doc_no, "COMMI_DOC", "left=50, top=50, width=850, height=600, scrollbars=yes");
		}else{
			window.open("/fms2/commi/commi_doc_u.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_c_c_fee.jsp&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&doc_no="+doc_no, "COMMI_DOC", "left=50, top=50, width=850, height=600, scrollbars=yes");		
		}
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='emp_id' value='<%=emp_id%>'>
<input type='hidden' name='cust_st' value='<%=cust_st%>'>
<input type='hidden' name='commi_size' value='<%=commi_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1450'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='40%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=8% class=title>연번</td>
                    <td width=20% class=title>계약번호</td>
                    <td width=17% class=title>계약자</td>
                    <td width=15% class=title>출고일자</td>
                    <td width=20% class=title>차량번호</td>
                    <td width=20% class=title>차종</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='60%'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
        			<td width=11% class=title>수당구분</td>
        			<td width=12% class=title>지급수수료</td>
        			<td width=10% class=title>세전가감액</td>
        			<td width=13% class=title>과세기준액</td>										
                    <td width=10% class=title>소득세</td>
                    <td width=10% class=title>주민세</td>
                    <td width=10% class=title>세금</td>
                    <td width=13% class=title>차인지급액</td>
                    <td width=11% class=title>지급날짜</td>
		        </tr>
		    </table>
	    </td>
	</tr>
    <%if(commi_size > 0){%>
	<tr>
	    <td class='line' width='40%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < commi_size ; i++){
			CommiBean commi = (CommiBean)commis.elementAt(i);%>
                <tr> 
                    <td width=8% align='center'><%=i+1%></td>
                    <td width=20% align='center'><a href="javascript:commi_doc('<%=commi.getRent_mng_id()%>','<%=commi.getRent_l_cd()%>','<%=commi.getDoc_no()%>')" title='문서처리전'><%=commi.getRent_l_cd()%></a></td>
                    <td width=17% align='center'><span title='<%=commi.getFirm_nm()%>'><%=Util.subData(commi.getFirm_nm(), 6)%></span></td>
                    <td width=15%  align='center'><%=commi.getDlv_dt()%></td>
                    <td width=20%  align='center'><%=commi.getCar_no()%></td>
                    <td width=20% align='center'><span title='<%=commi.getCar_nm()+" "+commi.getCar_name()%>'><%=Util.subData(commi.getCar_nm()+" "+commi.getCar_name(), 6)%></span></td>
                </tr>
          <%}%>
            </table>
        </td>
	    <td class='line' width='60%'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%for(int i = 0 ; i < commi_size ; i++){
				CommiBean commi = (CommiBean)commis.elementAt(i);
				int a_amt = 0;
				int commi_amt = commi.getCommi();
				if(commi.getAdd_st1().equals("1")) a_amt =+ commi.getAdd_amt1();
				if(commi.getAdd_st2().equals("1")) a_amt =+ commi.getAdd_amt2();
				if(commi.getAdd_st3().equals("1")) a_amt =+ commi.getAdd_amt3(); 
				
				commi_amt += commi.getDlv_con_commi();
				commi_amt += commi.getDlv_tns_commi();
				commi_amt += commi.getAgent_commi();
				%>
                <tr>
                    <td width=11% align='center'><%=commi.getCommi_st()%></td>
                    <td width=12%' align='right'><%=Util.parseDecimal(commi_amt)%></td>			  
                    <td width=10%' align='right'><%=Util.parseDecimal(a_amt)%></td>			  
                    <td width=13%' align='right'><%=Util.parseDecimal(commi_amt+a_amt)%></td>			  
                    <td width=10% align='right'><%=Util.parseDecimal(commi.getInc_amt())%></td>
                    <td width=10% align='right'><%=Util.parseDecimal(commi.getRes_amt())%></td>
                    <td width=10% align='right'><%=Util.parseDecimal(commi.getTot_amt())%></td>
                    <td width=13% align='right'><%=Util.parseDecimal(commi.getDif_amt())%></td>
                    <td width=11% align='center'><%=commi.getSup_dt()%></td>	  				
		        </tr>
		<%}%>
		    </table>
	    </td>
    <%}else{%>                     
    <tr>
	    <td class='line' width='40%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'>등록된 지급수수료가 없습니다</td>
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
    <%}%>
</table>
</form>
</body>
</html>
