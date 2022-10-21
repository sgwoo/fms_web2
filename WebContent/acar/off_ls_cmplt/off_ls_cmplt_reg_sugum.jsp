<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.user_mng.* "%>
<%@ page import="acar.offls_sui.*,  acar.asset.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="olsBean" class="acar.offls_sui.Offls_suiBean" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="sscBean" class="acar.offls_sui.Scd_sui_contBean" scope="page"/>
<jsp:useBean id="ssjBean" class="acar.offls_sui.Scd_sui_janBean" scope="page"/>
<jsp:useBean id="se_bean" class="acar.offls_actn.Offls_sui_etcBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String actn_dt = request.getParameter("actn_dt")==null?"":request.getParameter("actn_dt");
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	
	Scd_sui_contBean[] sscbs = olsD.getScd_sui_cont(car_mng_id);
	Scd_sui_janBean[] ssjbs = olsD.getScd_sui_jan(car_mng_id);

	
	int auc_chk = olsD.getAuctionChk(car_mng_id);
	
	AssetDatabase as_db = AssetDatabase.getInstance();
		
	se_bean = as_db.getInfoComm(car_mng_id);

	Hashtable ht = as_db.getSearch_auction(car_mng_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function cont_sugum(iuc)
{
	var fm = document.form1;
	if(iuc=="i"){
		if(!confirm('�Ա� �Ͻðڽ��ϱ�?')){ return; }
	}else if(iuc=="u"){
		if(!confirm('���� �Ͻðڽ��ϱ�?')){ return; }
	}else if(iuc=="c"){
		if(!confirm('��� �Ͻðڽ��ϱ�?')){ return; }
	}
	fm.gubun.value = iuc;
	fm.action = "/acar/off_ls_sui/off_ls_sui_reg_cont_sugum.jsp";
	fm.target = "i_no";
	fm.submit();
}

function jan_sugum(iuc)
{
	var fm = document.form1;
	if(iuc=="i"){
		if(!confirm('�Ա� �Ͻðڽ��ϱ�?')){ return; }
	}else if(iuc=="u"){
		if(!confirm('���� �Ͻðڽ��ϱ�?')){ return; }
	}else if(iuc=="c"){
		if(!confirm('��� �Ͻðڽ��ϱ�?')){ return; }
	}
	fm.gubun.value = iuc;
	fm.action = "/acar/off_ls_sui/off_ls_sui_reg_jan_sugum.jsp";
	fm.target = "i_no";
	fm.submit();
}

function update_sui_etc(iuc)
{
	var fm = document.form1;
	
	if(!confirm('���� �Ͻðڽ��ϱ�?')){ return; }

	fm.action = "/acar/off_ls_sui/off_ls_sui_etc_reg_a.jsp";
	fm.target = "i_no";
	fm.submit();
}

function set_buy_v_amt(gubun){
		var fm = document.form1;	
		
		if ( gubun == "1" ) {
			fm.comm1_vat.value 		= parseDecimal(toInt(parseDigit(fm.comm1_sup.value)) * 0.1 ); 
	    } else if ( gubun == "2" ) {
	    	fm.comm2_vat.value 		= parseDecimal(toInt(parseDigit(fm.comm2_sup.value)) * 0.1 );
	    } else if ( gubun == "3" ) {
	    	fm.comm3_vat.value 		= parseDecimal(toInt(parseDigit(fm.comm3_sup.value)) * 0.1 );
		} else if ( gubun == "4" ) {
	    	fm.comm4_vat.value 		= parseDecimal(toInt(parseDigit(fm.comm4_sup.value)) * 0.1 );
		}
		
		set_buy_amt(gubun);			
}	

	//�ݾ׼���
function set_buy_amt(gubun){
		var fm = document.form1;	
		
		if ( gubun == "1" ) {
			fm.comm1_tot.value 		= parseDecimal(toInt(parseDigit(fm.comm1_sup.value)) + toInt(parseDigit(fm.comm1_vat.value)));		
		} else if ( gubun == "2" ) {
			fm.comm2_tot.value 		= parseDecimal(toInt(parseDigit(fm.comm2_sup.value)) + toInt(parseDigit(fm.comm2_vat.value)));	
		} else if ( gubun == "3" ) {		
			fm.comm3_tot.value 		= parseDecimal(toInt(parseDigit(fm.comm3_sup.value)) + toInt(parseDigit(fm.comm3_vat.value)));		
		}	
}
		

function tot_buy_amt(gubun){
		var fm = document.form1;		
		
		if ( gubun == "1" ) {	
			fm.comm1_sup.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.comm1_tot.value))));
			fm.comm1_vat.value 		= parseDecimal(toInt(parseDigit(fm.comm1_tot.value)) - toInt(parseDigit(fm.comm1_sup.value)));	
		} else if (	gubun == "2" ) {	
			fm.comm2_sup.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.comm2_tot.value))));
			fm.comm2_vat.value 		= parseDecimal(toInt(parseDigit(fm.comm2_tot.value)) - toInt(parseDigit(fm.comm2_sup.value)));	
		} else if ( gubun == "3" ) { 
			fm.comm3_sup.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.comm3_tot.value))));
			fm.comm3_vat.value 		= parseDecimal(toInt(parseDigit(fm.comm3_tot.value)) - toInt(parseDigit(fm.comm3_sup.value)));	
		} else if ( gubun == "4" ) { 
			fm.comm4_sup.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.comm4_tot.value))));
			fm.comm4_vat.value 		= parseDecimal(toInt(parseDigit(fm.comm4_tot.value)) - toInt(parseDigit(fm.comm4_sup.value)));	
		}	
}	
	
	//��ĵ���
function scan_reg(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&car_mng_id=<%=car_mng_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}
	//��ĵ����
function scan_del(){
		var theForm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
		theForm.target = "i_no"
		theForm.action = "del_scan_a.jsp";
		theForm.submit();
}
	
		//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/sui/"+theURL;
		window.open(theURL,winName,features);
}
	
-->
</script>
</head>

<body>
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">

<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ű���� �Ա���Ȳ</span></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;<span class=style3><font color=red>1. ����</font></span></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    <tr>
	<%if(sscbs.length > 0){%>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=15%  class='title'> ȸ�� </td>
                    <td width=17% class='title'> ����</td>
                    <td width=17% class='title'> ������ </td>
                    <td width=17% class='title'> �Ա��� </td>
                    <td width=17% class='title'> �Աݾ� </td>
                    <td width=17% class='title'>&nbsp; </td>
                </tr>
 	  	<%for(int i=0; i<sscbs.length; i++){%>
                <tr> 
                    <td align='center'> 
                      <input type='text' name='c_tm' value='<%=sscbs[i].getTm()%>' size='2' class='whitenum' readonly>
                      ȸ</td>
                    <td align='right'> 
                      <input type='text' name='c_cont_amt' value='<%=Util.parseDecimal(sscbs[i].getCont_amt())%>' class='num'  size='10' readonly >
                      ��&nbsp;</td>
                    <td align='center'> 
                      <input type='text' name='c_est_dt' value='<%=AddUtil.ChangeDate2(sscbs[i].getEst_dt())%>' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align='center'> 
                      <input type='text' name='c_pay_dt' value='<%=AddUtil.ChangeDate2(sscbs[i].getPay_dt())%>' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align='right'> 
                      <input type='text' name='c_pay_amt' value='<%=Util.parseDecimal(sscbs[i].getPay_amt())%>' size='10' class='num' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td align='center'> <%if(i==sscbs.length-1){%><a href="javascript:cont_sugum('i')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_ig.gif border=0 align=absmiddle></a>&nbsp;
        			<a href="javascript:cont_sugum('u')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>&nbsp;
        			<a href="javascript:cont_sugum('c')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_cancel.gif border=0 align=absmiddle></a><%}%></td>
                </tr>
		<%}%>
            </table>
        </td>
	  <%}else{%>
	    <td>&nbsp;&nbsp;����.</td>
	  <%}%>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;<span class=style3><font color=red>2. �ܱ�</font></span></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    <tr> 
	<%if(ssjbs.length > 0){%>
        <td class="line" width="100%"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='15%'  class='title'> ȸ�� </td>
                    <td width='17%' class='title'> �ܱ�</td>
                    <td width='17%' class='title'> ������ </td>
                    <td width='17%' class='title'> �Ա��� </td>
                    <td width='17%' class='title'> �Աݾ� </td>
                    <td width='17%' class='title'>&nbsp; </td>
                </tr>
		<%for(int i=0; i<ssjbs.length; i++){%> 
                <tr> 
                    <td align='center'> 
                      <input type='text' name='j_tm' value='<%=ssjbs[i].getTm()%>' size='2' class='whitenum' readonly>
                      ȸ</td>
                    <td align='right'> 
                      <input type='text' name='j_jan_amt' value='<%=Util.parseDecimal(ssjbs[i].getJan_amt())%>' class='num'  size='10' readonly >
                      ��&nbsp;</td>
                    <td align='center'> 
                      <input type='text' name='j_est_dt' value='<%=AddUtil.ChangeDate2(ssjbs[i].getEst_dt())%>' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align='center'> 
                      <input type='text' name='j_pay_dt' value='<%=AddUtil.ChangeDate2(ssjbs[i].getPay_dt())%>' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align='right'> 
                      <input type='text' name='j_pay_amt' value='<%=Util.parseDecimal(ssjbs[i].getPay_amt())%>' size='10' class='num' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ��&nbsp;</td>
                    <td align='center'><%if(i==ssjbs.length-1){%><a href="javascript:jan_sugum('i')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_ig.gif border=0 align=absmiddle></a>&nbsp;
        			<a href="javascript:jan_sugum('u')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>&nbsp;
        			<a href="javascript:jan_sugum('c')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_cancel.gif border=0 align=absmiddle></a><%}%></td>
                </tr>
		<%}%>
            </table>
        </td>
	    <%}else{%>
	    <td>&nbsp;&nbsp;����.</td>
	  <%}%>
    </tr>
    <tr>
        <td></td>
    </tr>
    
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ű� ������</span></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    
  	<%if(auc_chk > 0){%>  
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=32%> ���ݰ�꼭������</td>
                    <%-- <td colspan="6" width=68%>&nbsp; <input type='text' name='comm_date' value="<%=AddUtil.ChangeDate2(se_bean.getComm_date())%>" size='10' class='text' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> --%>
                    <td colspan="6" width=68%>&nbsp; <input type='text' name='comm_date' value="<%if(se_bean.getComm_date().equals("")) {%><%=AddUtil.ChangeDate2(actn_dt)%><%} else {%><%=AddUtil.ChangeDate2(se_bean.getComm_date())%><%}%>" size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);'>                    
        			</td>
                </tr>
                <tr> 
                    <td class='title'  width=32%> ��Ź��ǰ�ڳ��������</td>
                    <td class='title' width=12%>���ް�</td>
                    <td width=11% align='left'>&nbsp; <input type='text' name='comm1_sup' value="<%=Util.parseDecimal(se_bean.getComm1_sup())%>"  size='13' class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); set_buy_v_amt('1');">
                    </td>
                    <td class='title' width=12%>����</td>
                    <td width=11%>&nbsp; <input type='text' size='13' name='comm1_vat' value="<%=Util.parseDecimal(se_bean.getComm1_vat())%>"  class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); set_buy_amt('1');">
                    </td>
                    <td class='title' width=11%>�հ�</td>
                    <td width=11%>&nbsp; <input type='text' size='13' name='comm1_tot' value="<%=Util.parseDecimal(se_bean.getComm1_tot())%>"  class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); tot_buy_amt('1');">  
                    </td>
                </tr>
                <tr> 
                    <td class='title'>��ǰ������</td>
                    <td class='title'>���ް�</td>
                    <td align='left'>&nbsp; <input type='text' name='comm2_sup' value="<%=Util.parseDecimal(se_bean.getComm2_sup())%>" size='13' class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); set_buy_v_amt('2');">
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp; <input type='text' size='13' name='comm2_vat' value="<%=Util.parseDecimal(se_bean.getComm2_vat())%>"   class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); set_buy_amt('2');">
                    </td>
                    <td class='title'>�հ�</td>
                    <td>&nbsp; <input type='text' size='13' name='comm2_tot' value="<%=Util.parseDecimal(se_bean.getComm2_tot())%>"   class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); tot_buy_amt('2');">  
                    </td>
                </tr>
				<tr> 
                    <td class='title'>����ǰ������</td>
                    <td class='title'>���ް�</td>
                    <td align='left'>&nbsp; <input type='text' name='comm4_sup' value="<%=Util.parseDecimal(ht.get("OUT_AMT_SUP"))%>" size='13' class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); set_buy_v_amt('4');">
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp; <input type='text' size='13' name='comm4_vat' value="<%=Util.parseDecimal(ht.get("OUT_AMT_VAT"))%>"   class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); set_buy_amt('4');">
                    </td>
                    <td class='title'>�հ�</td>
                    <td>&nbsp; <input type='text' size='13' name='comm4_tot' value="<%=Util.parseDecimal(ht.get("OUT_AMT"))%>"   class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); tot_buy_amt('4');">  
                    </td>
                </tr>
                <tr> 
                    <td class='title'> ��Ź��ǰ�ڹ���Ź�۴���Ա�</td>
                    <td class='title'>���ް�</td>
                    <td align='left'>&nbsp; <input type='text' name='comm3_sup' value="<%=Util.parseDecimal(se_bean.getComm3_sup())%>" size='13' class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); set_buy_v_amt('3');">
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp; <input type='text' size='13' name='comm3_vat' value="<%=Util.parseDecimal(se_bean.getComm3_vat())%>"  class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); set_buy_amt('3');">
                    </td>
                    <td class='title'>�հ�</td>
                    <td>&nbsp; <input type='text' size='13' name='comm3_tot' value="<%=Util.parseDecimal(se_bean.getComm3_tot())%>"  class='num' maxlength='13' onBlur="javascript:this.value=parseDecimal(this.value); tot_buy_amt('3');">  
                    </td>
                </tr>
                <tr>                 
                 	 <td class="title">������ĵ</td>
                     <td colspan=6>&nbsp; <%if(se_bean.getCommfile().equals("")){%><a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}else{%><a href="javascript:MM_openBrWindow('<%= se_bean.getCommfile() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= se_bean.getCommfile() %></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:scan_del()"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a><%}%></td>
                  	      
			   </tr>
            </table>
        </td>  
    </tr>
    
    <tr>
        <td align='right'>
		<% if ( nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���������",user_id) || nm_db.getWorkAuthUser("�������������",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id)  || nm_db.getWorkAuthUser("��༭�����˴����",user_id)  || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("����������",user_id) || nm_db.getWorkAuthUser("�Ű�������",user_id)  ) { %>    
        <a href="javascript:update_sui_etc('u')"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
		<% } %>      
        </td>
    </tr>
<% } %>   
     
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>