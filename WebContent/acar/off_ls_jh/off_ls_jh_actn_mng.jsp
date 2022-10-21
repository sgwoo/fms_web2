<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>
<jsp:useBean id="auction_re" class="acar.offls_actn.Offls_auction_reBean" scope="page"/>
<jsp:useBean id="auction_ban" class="acar.offls_actn.Offls_auction_banBean" scope="page"/>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 		= request.getParameter("seq")==null?"01":request.getParameter("seq");
	String actn_cnt 	= request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");
	String flag 		= request.getParameter("flag")==null?"n":request.getParameter("flag");	//��Ż��µ�� ���� �Ǵ��� FootWin()���� ����.
			
	olaBean 		= olaD.getActn_detail(car_mng_id);
	auction 		= olaD.getAuction(car_mng_id, seq);
	auction_re 		= olaD.getAuction_re(car_mng_id, auction.getActn_cnt());
	auction_ban 	= olaD.getAuction_ban(car_mng_id, auction.getActn_cnt());
	apprsl 			= olpD.getPre_apprsl(car_mng_id);

	int carpr 		= olaBean.getCar_cs_amt()+olaBean.getCar_cv_amt()+olaBean.getOpt_cs_amt()+olaBean.getOpt_cv_amt()+olaBean.getClr_cs_amt()+olaBean.getClr_cv_amt();
	
	double hp_pr 		= auction.getHp_pr();
	double hp_pr_per 	= (hp_pr*100)/carpr;
	
	String per_id 		= olaD.existsCar_mng_id(car_mng_id,auction.getActn_cnt());

	//����Ŵ��
	int pre_hp_pr 		= 0;
	double pre_hp_per 	= 0.0d;
	
	if((AddUtil.parseInt(auction.getSeq())-1)>0){
		pre_hp_pr 	= olaD.getPre_hp_pr(car_mng_id, seq);
		pre_hp_per 	= (hp_pr*100)/pre_hp_pr;
	}
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//���ɰ��(���ó�¥ - ���ʵ����)
	Hashtable ht = olaD.getCar_old(olaBean.getInit_reg_dt());
	
	//����
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "06", "03", "05");
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
//��Ż��º� ó��
function FootWin() {
	var theForm = document.form1;
<%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){
	if(auction.getActn_st().equals("2")){
		if(!auction_re.getCar_mng_id().equals("")){%>
			theForm.action = "off_ls_jh_actn_mng_re.jsp";
		<%}else if(!auction_ban.getCar_mng_id().equals("")){%>
			theForm.action = "off_ls_jh_actn_mng_ban.jsp";
		<%}else{%>
			theForm.action = "off_ls_jh_sc_in_choi.jsp";
		<%}%>
	<%}else if(auction.getActn_st().equals("3")){%>
		theForm.action = "off_ls_jh_sc_in_per.jsp";
	<%}else if(auction.getActn_st().equals("4")){%>
		theForm.action = "off_ls_jh_sc_in_nak.jsp";
	<%}else{%>
		theForm.action="off_ls_jh_sc_in_nodis.jsp";
	<%}
}else{
	if(auction.getActn_st().equals("3")){%>		
		theForm.action = "off_ls_jh_sc_in_per.jsp";
	<%}else if(auction.getActn_st().equals("4")){%>	
		theForm.action = "off_ls_jh_sc_in_nak.jsp";
	<%}else if(auction.getActn_st().equals("2")){
		if(auction.getChoi_st().equals("1")){%>
			theForm.action = "off_ls_jh_actn_mng_re.jsp";
		<%}else if(auction.getChoi_st().equals("2")){%>
			theForm.action = "off_ls_jh_actn_mng_ban.jsp";
		<%}else if(auction.getChoi_st().equals("3")){%>
			theForm.action = "off_ls_jh_sc_in_per.jsp";
		<%}
	}
	else%>	theForm.action = "off_ls_jh_sc_in_nodis.jsp";
<%}%>
	theForm.target = "st_foot";
	theForm.submit();
}

	//�������
	function per_talk() {
		var fm = document.form1;
		fm.action = "off_ls_jh_sc_in_per.jsp";
		fm.target = "st_foot";
		fm.submit();
	}

	//��Ű��� ���/����
	function updAuction(ioru) {
	//document.domain = "amazoncar.co.kr";
		var fm = document.form1;
					
		var auction_dt = ChangeDate2(fm.actn_dt.value);
		
		var ama_rsn = fm.ama_rsn.value;
		var actn_rsn = fm.actn_rsn.value;
		
		var ama_rsn_check = true;
		var actn_rsn_check = true;
		
		if (ama_rsn != "") {
			var tempStr = ama_rsn;
			var tempStr2 = "";
			for (var i = 0; i < tempStr.length; i++) {
				tempStr2 = tempStr.charCodeAt(i);
                // ū����ǥ(") Ư������ �Է�����
				if (tempStr2 == 34) {
					ama_rsn_check = false;
				}
			}
		}
		
		if (actn_rsn != "") {
			var tempStr = actn_rsn;
			var tempStr2 = "";
			for (var i = 0; i < tempStr.length; i++) {
				tempStr2 = tempStr.charCodeAt(i);
				// ū����ǥ(") Ư������ �Է�����
				if (tempStr2 == 34) {
					actn_rsn_check = false;
				}
			}
		}
		
		//����� üũ
		if (auction_dt == "") {
			alert("������� �Է��� �ּ���!");
			return;
		}
		
		//�������� �򰡿��� �Ϻ� Ư������ üũ
		if (ama_rsn_check == false) {
			alert("��Ű��� - �Ƹ���ī �򰡿��� ���� �� ����� �� ����\nū����ǥ(\")�� ���ԵǾ� �ֽ��ϴ�. Ȯ�����ּ���.");
			return;
		}
		if (actn_rsn_check == false) {
			alert("��Ű��� - ����� �򰡿��� ���� �� ����� �� ����\nū����ǥ(\")�� ���ԵǾ� �ֽ��ϴ�. Ȯ�����ּ���.");
			return;
		}

		if (ioru == "i") {
			if (!confirm('��� �Ͻðڽ��ϱ�?')) { return; }
		} else if (ioru == "u") {
			if (!confirm('���� �Ͻðڽ��ϱ�?')) { return; }
		}
<%if(nm_db.getWorkAuthUser("���ó��",user_id)){%>
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/off_ls_jh_actn_mng_upd2.jsp";
<%} else {%>
		fm.action = "off_ls_jh_actn_mng_upd.jsp";
<%}%>
		fm.target = "i_no";
		fm.submit();
	}

	//�����κ���
	function cngUAuction() {
		var fm = document.form1;
		if(!confirm('���� �Ͻðڽ��ϱ�?')){ return; }
		fm.action = "off_ls_jh_actn_mng_cngU.jsp";
		fm.target = "i_no";
		fm.submit();	
	}

	//�����������Һ��ڰ� %
	function getHpprPer(val) {
		var fm = document.form1;
		
		var hp_pr 	= toInt(parseDigit(fm.hp_pr.value));
		var car_pr 	= toInt(parseDigit(fm.car_pr.value));
		var per 	= (hp_pr*100)/car_pr;
		
		fm.hp_pr_per.value = parseFloatCipher3(per, 2);

		return parseDecimal(val);
	}
	
	//�ǰ�ų����� ���
	function set_janga() {	
		var fm = document.sh_form;
		var fm2 = document.form1;
		var auction_dt = ChangeDate2(fm2.actn_dt.value);
		if (auction_dt == "") {
			alert("������� �Է��� �ּ���!");
			return;
		}
		fm.rent_st.value 	= "1"; //�縮��
		fm.rent_dt.value 	= fm2.actn_dt.value;
		fm.action = '/acar/secondhand/getSecondhandJanga.jsp';
		fm.target = '_blank';
		fm.submit();
	}
	
	//�ǰ�ų����� ��� - ���ν���
	function set_OsAmt() {	
		var fm = document.sh_form;
		var fm2 = document.form1;
		var auction_dt = ChangeDate2(fm2.actn_dt.value);
		if(auction_dt == ""){ 
			alert("������� �Է��� �ּ���!"); 
			return;
		}	
		fm.rent_st.value 	= "1"; //�縮��		
		fm.rent_dt.value 	= fm2.actn_dt.value;
		fm.action = '/acar/secondhand/getSecondhandOffls.jsp';
		fm.target = 'i_no';
		fm.submit();
	}	
	
	//�ǰ�ų����� ��� �̷� - ���ν���
	function set_OsAmt_h() {	
		var fm = document.sh_form;
		var fm2 = document.form1;
		var auction_dt = ChangeDate2(fm2.actn_dt.value);
		if(auction_dt == ""){ 
			alert("������� �Է��� �ּ���!"); 
			return;
		}	
		fm.rent_st.value 	= "1"; //�縮��		
		fm.rent_dt.value 	= fm2.actn_dt.value;
		fm.action = '/acar/secondhand/getSecondhandOffls_result.jsp';
		fm.target = '_blank';
		fm.submit();
	}		
//-->
</script>
<body bgcolor="#FFFFFF" text="#000000" onload="javascript:FootWin()">
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="car_mng_id"		value="<%=car_mng_id%>">  
  <input type='hidden' name="mode"			value="off_ls">    
  <input type='hidden' name="rent_dt"			value="">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="a_b"			value="36">     
  <input type='hidden' name="fee_opt_amt"		value="0">
  <input type='hidden' name="cust_sh_car_amt"		value="">   
  <input type='hidden' name="sh_amt"			value="0">     
  <input type='hidden' name="today_dist"		value="<%=apprsl.getKm()%>">
  <input type='hidden' name="jg_b_dt"			value="">
  <input type='hidden' name="a_j"			value="">  
</form>
<%if(nm_db.getWorkAuthUser("���ó��",user_id)){%>
<form action="" name="form1" method="POST" enctype="multipart/form-data">
<%}else{%>
<form action="" name="form1" method="post">
<%}%>

<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <td width="720"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ű���</span>&nbsp;&nbsp;&nbsp;(<%=seq%>)</td>
                <td align="right"> 
                              	
            	      <% if(auth_rw.equals("4")||auth_rw.equals("6")){%>
                        <%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){//�ֱٰ�ŷ��ڵ��ϰ��%>
            			          <%if(auction.getActn_cnt().equals("")){//���ȸ�����°��%>
            		                <a href='javascript:updAuction("i");'><img src=../images/center/button_reg.gif align=absmiddle border=0></a> 
            			          <%}else{%>
            		                <a href='javascript:updAuction("u");'><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
					                      <%if(auction.getActn_st().equals("4") && auction.getNak_pr()==0){%>
					                          <a href='javascript:cngUAuction();'>[�����κ���]</a> 
					                      <%}%>
            			          <%}%> 
                        <%}%>
            	      <% }%>	
                </td>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%">
                <tr> 
                    <td class='title' rowspan="2" width=15%>�������</td>
                    <td class='title' width=17%>��Ż���</td>
                    <td class='title' width=15%>���ȸ��</td>
                    <td class='title' width=17%>��ǰ��ȣ</td>
                    <td class='title' width=17%>�����</td>
                    <td class='title' width=19%>����Ƚ��</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){//�ֱٰ�ŷ��ڵ��ϰ��%>
                      
                      <%	if(auction.getActn_st().equals("0")){//��ǰ����%>
                      <select name="actn_st">
                        <option value="0" <%if(auction.getActn_st().equals("0")){%>selected<%}%>>��ǰ����</option>
                        <option value="1" <%if(auction.getActn_st().equals("1")){%>selected<%}%>>���������</option>
                      </select>
                      <%	}else if(auction.getActn_st().equals("1")||auction.getActn_st().equals("")){//���������%>
                      <select name="actn_st" onChange="javascript:FootWin()">
                        <option value="1" <%if(auction.getActn_st().equals("1")){%>selected<%}%>>���������</option>
                        <option value="2" <%if(auction.getActn_st().equals("2")){%>selected<%}%>>����</option>
                        <option value="3" <%if(auction.getActn_st().equals("3")){%>selected<%}%>>�������</option>
                        <option value="4" <%if(auction.getActn_st().equals("4")){%>selected<%}%>>����</option>
                      </select>
                      <%	}else if(auction.getActn_st().equals("2")){//����%>
                      <select name="actn_st" onChange="javascript:FootWin()">
                        <option value="2" <%if(auction.getActn_st().equals("2")){%>selected<%}%>>����</option>
                      </select>
                      <%	}else if(auction.getActn_st().equals("3")){//�������%>
                      <select name="actn_st" onChange="javascript:FootWin()">
                        <option value="3" <%if(auction.getActn_st().equals("3")){%>selected<%}%>>�������</option>
                      </select>
                      <%	}else if(auction.getActn_st().equals("4")){//����%>
                      <input type="hidden" name="actn_st" value="4">
                      ���� 
		      <%	}%>
		      
		      <%}else{//������ŷ��ڵ� �� �̷��� �� ���%>
            	      <%	if(auction.getActn_st().equals("2")){//�����ϰ��%>
                      <%		if(!per_id.equals("")){//������㳻���� �����ϸ�%>
                      <input type="hidden" name="actn_st_h" value="3">
                      ����(<a href="javascript:per_talk()">�������</a>) 
                      <%		}else{%>
                      <input type="hidden" name="actn_st_h" value="">
                      ���� 
                      <%		}%>
           	      <%	}else if(auction.getActn_st().equals("4")){//�����ϰ��%>
                      <input type="hidden" name="actn_st_h" value="4">
                      ���� 
                      <%	}else{//�� �ܴ� �߸��� ��Ż���%>
                      <input type="hidden" name="actn_st_h" value="">
                      �̷°��� 
                      <%	}%>
        	      <%}%>        	      
                    </td>
                    <td align="center"> 
                      <input class="text" type="text" name="actn_cnt" size="10" value="<%=auction.getActn_cnt()%>">
                      ȸ </td>
                    <td align="center"> 
                      <input class="text" type="text" name="actn_num" size="15" value="<%=auction.getActn_num()%>">
                    </td>
                    <td align="center"> 
                      <input class="text" type="text" name="actn_dt" size="15" value="<%=AddUtil.ChangeDate2(auction.getActn_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input class="white" type="text" name="seq_s" size="15" value="<%=AddUtil.parseInt(auction.getSeq())-1%>" readonly>
                    </td>
                </tr>
				
				<%if(nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("���ó��",user_id)||nm_db.getWorkAuthUser("�Ű�������",user_id)){%>				
				<tr>
					<td class='title'>��ǰ������(��)</td>
					<td  align="center"> <input class="num" type="text" name="out_amt" size="15" value="<%=AddUtil.parseDecimal(auction.getOut_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
					<td class='title'>��ĵ</td>
					<td colspan='3' align="center">
					
					<input type="file" name="offls_file" value="<%=auction.getOffls_file()%>" size="50"></td>
				</tr>
				<%}%>
				
            </table>
        </td>
        <td width=20>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" ><img src="/images/blank.gif" align="absmiddle" border="0"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tR>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' rowspan="2" width=15%>��������</td>
                    <td class='title' width=17%>�⺻����(��)</td>
                    <td class='title' width=15%>���۰�(��)</td>
                    <td class='title' width=17%>�����(��)</td>
                    <td class='title' width=9%>�������(%)</td>
                    <td class='title' width=8%>����Ŵ��(%)</td>
                    <td class='title' width=19%>��������(��)</td>
                </tr>
                <tr> 
                    <td  align="center"> 
                      <input class="num" type="text" name="car_pr" size="15" value="<%=AddUtil.parseDecimal(carpr)%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                    <td  align="center"> 
                      <input class="num" type="text" name="st_pr" size="15" value="<%=AddUtil.parseDecimal(auction.getSt_pr())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                    <td  align="center"> 
                      <input class="num" type="text" name="hp_pr" size="15" value="<%=AddUtil.parseDecimal(auction.getHp_pr())%>" onBlur='javascript:this.value=getHpprPer(this.value)'>
                    </td>
                    <td  align="center"> 
                      <input class="white" type="text" name="hp_pr_per" size="5" value="<%=AddUtil.parseDecimal(hp_pr_per)%>" readonly>
                    </td>
                    <td  align="center"><%=AddUtil.parseDecimal(pre_hp_per)%> 
                    </td>
                    <td  align="center">                       
                      <input class="num" type="text" name="o_s_amt" size="15" value="<%=AddUtil.parseDecimal(auction.getO_s_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                      <input type="button" class="button" value="���" onclick="set_OsAmt()"/>                      
                      <input type="button" class="button" value="�̷�" onclick="set_OsAmt_h()"/>                      
                    </td>
                </tr>
				
            </table>
        </td>
        <td width=20>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" height="7"><img src="/images/blank.gif" align="absmiddle" border="0"></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tR>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' rowspan="2" width=15%>��������</td>
                    <td class='title' width=17%>����</td>
                    <td class='title' width=15%>����</td>
                    <td class='title' width=17%>����Ÿ�</td>
                    <td class='title' width=17%>���ʵ����</td>
                    <td class='title' width=19%>����</td>
                </tr>
                <tr> 
                    <td  align="center"><%=olaBean.getCar_jnm()%>  <%=olaBean.getCar_nm()%></td>
                    <td  align="center"><%=AddUtil.subData(olaBean.getColo(),8)%></td>
                    <td  align="center"><%=AddUtil.parseDecimal(olaBean.getKm())%>km</td>
                    <td  align="center"><%=AddUtil.ChangeDate2(olaBean.getInit_reg_dt())%></td>
                    <td  align="center"><%=ht.get("YEAR")%>�� <%=ht.get("MONTH")%>����</td>
                </tr>
            </table>
        </td>
        <td width=20>&nbsp;</td>
    </tr>
	<tr> 
        <td colspan="2" height="7"><img src="/images/blank.gif" align="absmiddle" border="0"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tR>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0"  width="100%">
                <tr> 
                    <td class='title' rowspan="3" width=15%>��������</td>
                    <td class='title' width=17%>����</td>
                    <td class='title' width=15%>����</td>
                    <td class='title' width=34%>�򰡿���</td>
                    <td class='title' width=19%>����</td>
                </tr>
                <tr> 
                    <td class='title' align="center">�Ƹ���ī(10������)</td>
                    <td  align="center"> 
                      <input class="text" type="text" name="ama_jum" size="15" value="<%=auction.getAma_jum()%>">
                    </td>
                    <td> &nbsp; 
                      <input class="text" type="text" name="ama_rsn" size="55" value="<%=auction.getAma_rsn()%>">
                    </td>
                    <td align="center"> &nbsp; 
                      <input class="text" type="text" name="ama_nm" size="15" value="<%=auction.getAma_nm()%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title' align="center">�����(10������)</td>
                    <td  align="center"> 
                      <input class="text" type="text" name="actn_jum" size="15" value="<%=auction.getActn_jum()%>">
                    </td>
                    <td> &nbsp; 
                      <input class="text" type="text" name="actn_rsn" size="55" value="<%=auction.getActn_rsn()%>">
                    </td>
                    <td align="center"> &nbsp; 
                      <input class="text" type="text" name="actn_nm" size="15" value="<%=auction.getActn_nm()%>">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
