<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("CARD_SCD", "");
	int ck_size = card_kinds.size();	
	
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String s_sort = request.getParameter("s_sort")==null?"1":request.getParameter("s_sort");

	String s_scd_dt = request.getParameter("s_scd_dt")==null?"":request.getParameter("s_scd_dt");
	String e_scd_dt = request.getParameter("e_scd_dt")==null?"":request.getParameter("e_scd_dt");

	//ī�彺���� ����Ʈ ��ȸ
	Vector vt = new Vector();
	int vt_size = 0;	
	
	if(!card_kind.equals("")){
		vt = CardDb.getCardIncomStat(card_kind, s_dt, s_sort, gubun1, s_scd_dt, e_scd_dt);
		vt_size = vt.size();	
	}
	
	long total_amt0 = 0;
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
	
	
	if(vt_size > 0){
    for (int i = 0 ; i < vt_size ; i++){
      Hashtable ht = (Hashtable)vt.elementAt(i);
      //if(i==0)         s_scd_dt  = String.valueOf(ht.get("SCD_DT"));
      //if(i+1==vt_size) e_scd_dt  = String.valueOf(ht.get("SCD_DT"));
    }
	}	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function cng_card_kind(value){
		var fm = document.form1;
		fm.s_dt.value = '';
		fm.action = "card_incom_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
  
	function card_Search(){
		var fm = document.form1;
		fm.action="card_incom_sc.jsp";
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') card_Search();
	}	 
	
	function search_insidebank()
	{
		var fm = document.form1;
		var t_wd = fm.card_kind.options[fm.card_kind.selectedIndex].text;
		if(t_wd == '����ī��') t_wd = 'K����Ʈ';
		if(t_wd == '�츮��') t_wd = '��ī��';
		if(t_wd == '�츮BCī��') t_wd = '��ī��';
		if(t_wd == 'KB����ī��') t_wd = '����ī��';
		window.open("/fms2/account/shinhan_erp_demand_inside.jsp?from_page=/card/cash_back/card_incom_sc.jsp&t_wd="+replaceString("-","",fm.incom_dt.value)+"&s_wd="+t_wd, "AncDisp", "left=100, top=100, width=1100, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		 
	
	function setScdIncom(idx){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		var scd_amt = toInt(parseDigit(fm.incom_amt.value));
		if(scd_amt == 0){
			alert('�Ա��Ѿ��� �����ϴ�.'); return;
		}else{
			if(tm == 1){
					if(scd_amt > 0){
						if(scd_amt > toInt(parseDigit(fm.save_amt.value))){
							fm.base_incom_amt.value = fm.save_amt.value;
						}else{
							fm.base_incom_amt.value = parseDecimal(scd_amt);
						}
					}
			}else{
				for(var i = idx ; i < toInt(fm.size.value) ; i ++){	
					if(scd_amt > 0){
						if(scd_amt > toInt(parseDigit(fm.save_amt[i].value))){
							fm.base_incom_amt[i].value = fm.save_amt[i].value;
						}else{
							fm.base_incom_amt[i].value = parseDecimal(scd_amt);
						}
						scd_amt = scd_amt - toInt(parseDigit(fm.base_incom_amt[i].value));
					}
				}
			}
			cal_rest();
		}	
	}
	
	function cal_rest(){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		if(tm == 1){
				fm.rest_amt.value = parseDecimal(toInt(parseDigit(fm.save_amt.value)) - toInt(parseDigit(fm.base_incom_amt.value)) - toInt(parseDigit(fm.m_amt.value)));
				if(toInt(parseDigit(fm.base_incom_amt.value)) > 0 && toInt(parseDigit(fm.rest_amt.value)) >0){
					fm.incom_bigo2.value = '�ܾ׹߻�';
				}else{
					fm.incom_bigo2.value = '';
				}
		}else{
			for(var i = 0 ; i < tm ; i ++){
				fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.save_amt[i].value)) - toInt(parseDigit(fm.base_incom_amt[i].value)) - toInt(parseDigit(fm.m_amt[i].value)));
				if(toInt(parseDigit(fm.base_incom_amt[i].value)) > 0 && toInt(parseDigit(fm.rest_amt[i].value)) >0){
					fm.incom_bigo2[i].value = '�ܾ׹߻�';
				}else{
					fm.incom_bigo2[i].value = '';
				}
			}
		}
		cal_total();
	}
	
	function cal_total(){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		var incom_amt = 0;
		var m_amt = 0;
		var rest_amt = 0;
		var l_amt = 0;
		if(tm == 1){
				incom_amt += toInt(parseDigit(fm.base_incom_amt.value));
				m_amt     += toInt(parseDigit(fm.m_amt.value));
				rest_amt  += toInt(parseDigit(fm.rest_amt.value));
		}else{
			for(var i = 0 ; i < tm ; i ++){	
				incom_amt += toInt(parseDigit(fm.base_incom_amt[i].value));
				m_amt     += toInt(parseDigit(fm.m_amt[i].value));
				rest_amt  += toInt(parseDigit(fm.rest_amt[i].value));
			}
		}
		if(fm.card_kind.options[fm.card_kind.selectedIndex].text!='����ī��' && incom_amt < toInt(parseDigit(fm.incom_amt.value)) ) {
			if(tm == 1){
				fm.m_amt.value = parseDecimal( -1 * (toInt(parseDigit(fm.incom_amt.value)) - incom_amt) );
				l_amt = toInt(parseDigit(fm.m_amt.value));
				fm.incom_bigo.value = '���Ա�';
			}else{
				fm.m_amt[tm-1].value = parseDecimal( -1 * (toInt(parseDigit(fm.incom_amt.value)) - incom_amt) );
				l_amt = toInt(parseDigit(fm.m_amt[tm-1].value));
				fm.incom_bigo[tm-1].value = '���Ա�';
			}
		}
		if(fm.card_kind.options[fm.card_kind.selectedIndex].text=='����ī��'){
			fm.t_incom_amt.value = parseDecimal(incom_amt);	
		}else{
			fm.t_incom_amt.value = parseDecimal(incom_amt-l_amt);
		}
		
		fm.t_m_amt.value = parseDecimal(m_amt);
		fm.t_rest_amt.value = parseDecimal(rest_amt);
		
		
	}	
	
	function cal_dt(){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		var dt = '';
		if(tm == 1){
				if(replaceString("-","",fm.incom_dt.value) == replaceString("-","",fm.est_dt.value) ){
					fm.start_scd.checked = true;
					setScdIncom(0);
				}
		}else{
			for(var i = 0 ; i < tm ; i ++){	
				if(dt == '' && replaceString("-","",fm.incom_dt.value) == replaceString("-","",fm.est_dt[i].value) ){
					fm.start_scd[i].checked = true;
					dt = replaceString("-","",fm.est_dt[i].value);
					setScdIncom(i);
				}
			}
		}	
	}
	
	function Save(){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		if(fm.incom_amt.value == '0' || fm.t_incom_amt.value == '0'){
			alert('�Ա��Ѿ� �� �Աݾ� �հ谡 �����ϴ�.'); return;
		}
		if(fm.card_kind.options[fm.card_kind.selectedIndex].text=='�Ｚī��'){
			if(fm.incom_amt.value != fm.t_incom_amt.value){
				if(fm.incom_amt.value != parseDecimal(toInt(parseDigit(fm.t_incom_amt.value))+toInt(parseDigit(fm.t_m_amt.value)))){
					alert('�Ա��Ѿ� �� �Աݾ� �հ谡 �ٸ��ϴ�.'); return;
				}	
			}			
		}else{
			if(fm.incom_amt.value != fm.t_incom_amt.value){
				alert('�Ա��Ѿ� �� �Աݾ� �հ谡 �ٸ��ϴ�.'); return;
			}
		}
		var chk = 0;
		if(tm == 1){
				if(fm.incom_bigo2.value != ''){
					chk = chk + 1;
				}
		}else{
			for(var i = 0 ; i < tm ; i ++){	
				if(fm.incom_bigo2[i].value != ''){
					chk = chk + 1;
				}
			}
		}
		if(chk >0){
			if(!confirm("�ܾ׹߻��� �ֽ��ϴ�. �Ա�ó���Ͻðڽ��ϱ�?"))	return;
		}else{
			if(!confirm("�Ա�ó���Ͻðڽ��ϱ�?"))	return;
		}
		fm.action = "card_incom_sc_a.jsp";
		//fm.target = "i_no";
		fm.target = "_self";
		fm.submit();		
	}
	
	function setAmtType(amtset){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		//�ڵ�
		if(amtset == '1'){
			if(tm == 1){
					fm.base_incom_amt.readOnly = true;
					fm.rest_amt.readOnly = true;
					fm.base_incom_amt.className = "whitenum";
					fm.rest_amt.className = "whitenum";
			}else{
				for(var i = 0 ; i < tm ; i ++){	
					fm.base_incom_amt[i].readOnly = true;
					fm.rest_amt[i].readOnly = true;
					fm.base_incom_amt[i].className = "whitenum";
					fm.rest_amt[i].className = "whitenum";
				}
			}
			fm.incom_amt.readOnly = true;
			fm.incom_amt.className = "whitenum";
		//����
		}else{
			if(tm == 1){
					fm.base_incom_amt.readOnly = false;
					fm.rest_amt.readOnly = false;
					fm.base_incom_amt.className = "num";
					fm.rest_amt.className = "num";
			}else{
				for(var i = 0 ; i < tm ; i ++){	
					fm.base_incom_amt[i].readOnly = false;
					fm.rest_amt[i].readOnly = false;
					fm.base_incom_amt[i].className = "num";
					fm.rest_amt[i].className = "num";
				}
			}
			//fm.incom_amt.readOnly = false;
			//fm.incom_amt.className = "num";
		}
	}
	
	
	 function CardStatBase(scd_dt, reg_code){
		var fm = document.form1;
		fm.scd_dt.value = scd_dt;
		fm.reg_code.value = reg_code;
		fm.action = "card_incom_list.jsp";
		window.open("about:blank", "CardIncomList", "left=350, top=50, width=1000, height=800, scrollbars=yes, status=yes");
		fm.target = "CardIncomList";
		fm.submit();
  }
  
  function CardStatBaseAllUp(scd_dt){
		var fm = document.form1;
		fm.scd_dt.value = scd_dt;
		fm.action = "card_incom_list_allup.jsp";
		window.open("about:blank", "CardIncomListAll", "left=350, top=50, width=1300, height=800, scrollbars=yes, status=yes");
		fm.target = "CardIncomListAll";
		fm.submit();
  }
	  
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='st' value=''>
<input type='hidden' name='scd_dt' value=''>
<input type='hidden' name='reg_code' value=''>
<input type='hidden' name='tran_date_seq' value=''>
<input type='hidden' name='acct_seq' value=''>
<input type='hidden' name='bank_id' value=''>
<input type='hidden' name='bank_nm' value=''>
<input type='hidden' name='bank_no' value=''>
<input type='hidden' name='size' value='<%=vt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Աݿ���(ī��ĳ����)</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%'  class='title'>�ŷ�ó��</td>
            <td>&nbsp;
              <select name="card_kind" id="card_kind" onChange="javascript:cng_card_kind(this.value)" >
                <option value=''>����</option>
                <%if(ck_size > 0){
                    for (int i = 0 ; i < ck_size ; i++){
                      Hashtable ht = (Hashtable)card_kinds.elementAt(i);
                %>
                <option value='<%= ht.get("CODE") %>' <%if(card_kind.equals(String.valueOf(ht.get("CODE")))){%>selected<%}%>><%= ht.get("CARD_KIND") %></option>
                <%	}
                  }
                %>
              </select>
              <%//if(!card_kind.equals("") && vt_size > 0){%>
              &nbsp;&nbsp;
              �������� : <input name="s_dt" type="text" class="text" value="<%=s_dt%>" size="12" onKeyDown="javasript:enter()" style='IME-MODE: active'>
              &nbsp;<a href="javascript:card_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
              <%//	if(vt_size > 0){%>
              &nbsp;&nbsp;
              <%//		if(!s_dt.equals("")){%>
              <a href="javascript:CardStatBaseAllUp('')" onMouseOver="window.status=''; return true" title="����Ʈ ����"><img src="/images/esti_detail.gif" align=absmiddle border="0"></a>
              <%//		}%>
              (ĳ�����ϰ�ó�� �����:
              <input name="s_scd_dt" type="text" class="text" value="<%=s_scd_dt%>" size="12">~<input name="e_scd_dt" type="text" class="text" value="<%=e_scd_dt%>" size="12">
              )
              <%//	}%>
              <%//}else{%>
              <!-- <input type='hidden' name='s_dt' value=''> -->
              <%//}%>
              &nbsp;&nbsp;
              �뵵���� : <select name="gubun1" id="gubun1">
                <option value='' <%if(gubun1.equals("")){%>selected<%}%>>��ü</option>
                <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>�����ڱ�</option>
                <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>�������</option>
                <!-- <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>���ݳ���</option> -->
                <%if(ck_acar_id.equals("000029")){ %>
                <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>����������</option>
                <%}%>
              </select>
              (8/17���� ��������)
              &nbsp;&nbsp;
              1�������� : <select name="s_sort" id="s_sort">
                <option value='1' <%if(s_sort.equals("1")){%>selected<%}%>>������</option>
                <option value='3' <%if(s_sort.equals("3")){%>selected<%}%>>�����</option>
                <option value='2' <%if(s_sort.equals("2")){%>selected<%}%>>�����ݾ�</option>
              </select>              
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(!card_kind.equals("")){%>
    <tr> 
        <td class=h></td>
    </tr>	
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' rowspan='2' class='title'>�������</td>
                    <td width='12%' rowspan='2' class='title'>���ݾ�</td>
                    <td width='10%' rowspan='2' class='title'>�����ݾ�</td>
                    <td colspan='2' class='title'>�Ա�</td>
                    <td width='12%' rowspan='2' class='title'>�ܾ�</td>
                    <td width='12%' rowspan='2' class='title'>��������<br>(������ ����)</td>
                    <td width='15%' rowspan='2' class='title'>����</td>
                    <td width='7%' rowspan='2' class='title'>-</td>
                </tr>
                <tr>
                    <td width='12%' class='title'>�Աݾ�</td>
                    <td width='10%' class='title'>����ó��</td>
                </tr>                
                <%
                	String f_est_dt = "";
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            total_amt0 = total_amt0 + AddUtil.parseLong(String.valueOf(ht.get("SCD_AMT")));
					            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("SAVE_AMT")));
					            if(i==0) f_est_dt = AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")));
					      %>
                <tr>
                    <td class='title'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SCD_DT")))%>
                    	<input type='hidden' name='serial' value='<%=ht.get("SERIAL")%>'>
                    	<input type='hidden' name='tm' value='<%=ht.get("TM")%>'>
                    	<input type='hidden' name='est_dt' value='<%=ht.get("EST_DT")%>'>
                    </td>
                    <td align="center"><a href="javascript:CardStatBaseAllUp('<%=ht.get("SCD_DT")%>')" onMouseOver="window.status=''; return true" title="����Ʈ ����"><img src="/images/esti_detail.gif" align=absmiddle border="0"></a><input type="text" name="scd_amt" size="12" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SCD_AMT")))%>" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="save_amt" size="12" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SAVE_AMT")))%>" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="base_incom_amt" size="12" value="0" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value);cal_rest();'>��</td>
                    <td align="center"><input type="text" name="m_amt" size="8" value="0" class=num onBlur='javascript:this.value=parseDecimal(this.value);cal_rest();'>��</td>
                    <td align="center"><input type="text" name="rest_amt" size="12" value="0" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type='radio' name="start_scd" value='<%=i%>' onClick="javascript:setScdIncom(<%=i%>)">
                    	<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%>
                    </td>
                    <td align="center"><input type="text" name="incom_bigo" size="25" value="<%=ht.get("INCOM_BIGO")%>" class=text></td>
                    <td align="center"><input type="text" name="incom_bigo2" size="6" value="" class=whitetext readonly></td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title'>�հ�</td>
                    <td align="center"><input type="text" name="t_scd_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt0)%>" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="t_save_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt1)%>" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="t_incom_amt" size="12" value="" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="t_m_amt" size="8" value="" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="t_rest_amt" size="12" value="" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="9" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td>�� �ϰ��Ա�ó��
        	&nbsp;<a href='javascript:search_insidebank()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_search.gif" align=absmiddle border="0"></a>	
        </td>
    </tr>      
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' class='title'>�Ա�����</td>
                    <td width='10%'>&nbsp;<input type="text" name="incom_dt" class="text" value="<%=f_est_dt%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td width='10%' class='title'>�Ա��Ѿ�</td>
                    <td width='10%'>&nbsp;<input type="text" name="incom_amt" size="12" value="0" class=num onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                    <td width='10%' class='title'>�ڵ���ǥ</td>
                    <td width='10%'>&nbsp;<input type="checkbox" name="autodoc_yn" value="Y" checked> ����</td>
                    <td width='10%' class='title'>�Աݹݿ�</td>
                    <td>&nbsp;
                    	<input type='radio' name="amtset" value='1' onClick="javascript:setAmtType(1)" checked>
                    	�ڵ�
                    	<input type='radio' name="amtset" value='2' onClick="javascript:setAmtType(2)">
                    	����
                    </td>
                    <td width='10%' class='title'>�ܾ׽�����</td>
                    <td width='10%' >&nbsp;<input type="checkbox" name="balance_reg_yn" value="Y"> ����</td>
                </tr>
            </table>
	    </td>
    </tr>
  <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
        <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�Աݴ��",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) || nm_db.getWorkAuthUser("ī��ĳ������",user_id)){%>
        <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
        <%}%>
      </td>
    </tr>    
    <tr> 
        <td class=h></td>
    </tr>  
    <tr> 
        <td>�� �ܾ׹߻��� ��� ����ó���� �ݾ����� �Է��Ͽ� ������ �� �ֽ��ϴ�. �����Ա��� ��쿡�� ����ó������ ������.</td>
    </tr>      
    <tr> 
        <td>�� �Աݻ���ϰ� �ܾ��� ���� �ִ� ��쿡�� �ܾ׽����ٿ��θ� �������� �����ϸ� �� �ݾ����� �������� �߰� �����մϴ�.</td>
    </tr>          
    <%}%>  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
