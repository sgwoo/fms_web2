<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String st = request.getParameter("st")==null?"":request.getParameter("st");
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	
	Vector vt = CardDb.getCardMonList(gubun1, st_dt, end_dt, st, card_kind);
	int vt_size = vt.size();	
	
	Vector vt2 = CardDb.getCardSaveList(card_kind);
	int vt_size2 = vt2.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	
	int save_per_chk_h =0;
	long count = 0;
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function Save(){
		var fm = document.form1;
		var ment = "수정하시겠습니까?";
		if(confirm(ment)){
			fm.action='card_mon_list_allup_a.jsp';
			//fm.target='i_no';
			fm.submit();
		}
	}
	
	function setScdSaveAmt(idx){
		var fm = document.form1;
		fm.m_amt[idx].value = parseDecimal( toInt(parseDigit(fm.save_amt[idx].value)) - toInt(parseDigit(fm.incom_amt[idx].value)) ); 
		setScdTotAmt();
	}
	
	function setScdTotAmt(){
		var fm = document.form1;
		var t_amt1 = 0;
		var t_amt2 = 0;
		var t_amt3 = 0;
		for(var i = 0 ; i < <%=vt_size%> ; i++){
			if(fm.scd_tm[i].value == '1'){
				t_amt3 = t_amt3 + toInt(parseDigit(fm.save_amt[i].value));
			}
			t_amt1 = t_amt1 + toInt(parseDigit(fm.incom_amt[i].value));
			t_amt2 = t_amt2 + toInt(parseDigit(fm.m_amt[i].value));
		}
		fm.t_incom_amt.value = parseDecimal(t_amt1);
		fm.t_m_amt.value     = parseDecimal(t_amt2);
		fm.t_save_amt.value  = parseDecimal(t_amt3);
		
		fm.c_base_save_amt.value = parseDecimal(t_amt3-toInt(parseDigit(fm.tt_base_save_amt.value)));
		fm.c_incom_amt.value = parseDecimal(toInt(parseDigit(fm.o_incom_amt.value))-t_amt1);
		fm.c_m_amt.value     = parseDecimal(toInt(parseDigit(fm.o_m_amt.value))-t_amt2);
		fm.c_save_amt.value  = parseDecimal(toInt(parseDigit(fm.o_save_amt.value))-t_amt3);
	}	
	
	function setTotAmt(){
		var fm = document.form1;
		var t_b_amt = 0;
		var t_s_amt = 0;
		var idx = 0;
		for(var i = 0 ; i < <%=vt_size%> ; i++){
			var t_amt1 = 0;
			var t_amt2 = 0;
			for(var j = 0 ; j < toInt(fm.scd_base_size[i].value) ; j++){
				t_amt1 = t_amt1 + toInt(parseDigit(fm.base_amt[idx].value));
				t_amt2 = t_amt2 + toInt(parseDigit(fm.base_save_amt[idx].value));
				idx++;
			}
			fm.t_base_amt[i].value 			= parseDecimal(t_amt1);
			fm.t_base_save_amt[i].value = parseDecimal(t_amt2);
			t_b_amt = t_b_amt + t_amt1;
			t_s_amt = t_s_amt + t_amt2;
		}
		fm.tt_base_amt.value = parseDecimal(t_b_amt);
		fm.tt_base_save_amt.value = parseDecimal(t_s_amt);
		fm.c_base_save_amt.value = parseDecimal(toInt(parseDigit(fm.t_save_amt.value))-t_s_amt);
	}

	function setSaveAmt(idx){
		var fm = document.form1;
		fm.base_save_amt[idx].value = parseDecimal( toInt(parseDigit(fm.base_amt[idx].value)) * toFloat(fm.save_per[idx].value) /100 ); 
		setTotAmt();
	}
	
	function setVenSaveAmt(idx){
		var fm = document.form1;
		for(var i = 0 ; i < <%=vt_size2%> ; i++){
			if(fm.s_ven_name[i].value == fm.ven_name[idx].value){
				fm.save_per[idx].value = fm.s_save_per[i].value; 
				fm.base_save_amt[idx].value = parseDecimal( toInt(parseDigit(fm.base_amt[idx].value)) * toFloat(fm.save_per[idx].value) /100 ); 
			}
		}
		setTotAmt();
	}
	
	function all_chk_saveper(){
		var fm = document.form1;
		for(var i = 0 ; i < toInt(fm.count.value) ; i++){
			if(fm.save_per_chk[i].value == '1'){
				for(var j = 0 ; j < <%=vt_size2%> ; j++){
					if(fm.s_ven_name[j].value == fm.ven_name[i].value){
						fm.save_per[i].value = fm.s_save_per[j].value; 
						fm.base_save_amt[i].value = parseDecimal( toInt(parseDigit(fm.base_amt[i].value)) * toFloat(fm.save_per[i].value) /100 ); 
					}
				}
			}
		}
		setTotAmt();
		all_incom_saveamt();
	}
	
	function all_auto_saveper(){
		var fm = document.form1;
		for(var i = 0 ; i < toInt(fm.count.value) ; i++){
				for(var j = 0 ; j < <%=vt_size2%> ; j++){
					if(fm.s_ven_name[j].value == fm.ven_name[i].value){
						fm.save_per[i].value = fm.s_save_per[j].value; 
						fm.base_save_amt[i].value = parseDecimal( toInt(parseDigit(fm.base_amt[i].value)) * toFloat(fm.save_per[i].value) /100 ); 
					}
				}
		}
		setTotAmt();
		all_incom_saveamt();
	}	
	
	function all_incom_saveamt(){
		var fm = document.form1;
		for(var i = 0 ; i < <%=vt_size%> ; i++){
			if(fm.scd_tm[i].value == '1'){
				fm.save_amt[i].value  = fm.t_base_save_amt[i].value; 
				fm.incom_amt[i].value = fm.save_amt[i].value;
			}
			fm.m_amt[i].value = parseDecimal( toInt(parseDigit(fm.save_amt[i].value)) - toInt(parseDigit(fm.incom_amt[i].value)) ); 
		}
		setScdTotAmt();
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='st' value='<%=st%>'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
<input type='hidden' name='size' value='<%=vt_size%>'>
<input type='hidden' name='size2' value='<%=vt_size2%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=c_db.getNameByIdCode("0031", card_kind, "")%> 월간 현항</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='2%' class='title'>연번</td>
                    <td width='7%' class='title'>입금일자</td>
                    <td width='7%' class='title'>사용금액</td>
                    <td width='7%' class='title'>적립금액</td>
                    <td width='7%' class='title'>입금금액</td>
                    <td width='5%' class='title'>손익금액</td>
                    <td width='65%' class='title'>내역</td>
                </tr>
            </table>
	    </td>
    </tr> 	  
    <tr><td class=h></td></tr>  
    <tr> 
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            Vector vt3 = new Vector();
											int vt_size3 = 0;	
					            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")));
					            total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("M_AMT")));
					            if(String.valueOf(ht.get("TM")).equals("1")){
					            	total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("SCD_AMT")));
					            	total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("SAVE_AMT")));
						            vt3 = CardDb.getCardStatBaseMonList(card_kind, String.valueOf(ht.get("SCD_DT")), String.valueOf(ht.get("EST_DT")), String.valueOf(ht.get("REG_CODE")));
												vt_size3 = vt3.size();	
					            }
					      %>
                <tr>
                    <td width='2%' align="center"><%=i+1%>
                    	<input type='hidden' name='scd_serial' value='<%=ht.get("SERIAL")%>'>
                    	<input type='hidden' name='scd_tm' value='<%=ht.get("TM")%>'>
                    	<input type='hidden' name='scd_amt' value='<%=ht.get("SCD_AMT")%>'>
                    	<input type='hidden' name='scd_base_size' value='<%=vt_size3%>'>
                    </td>
                    <td width='7%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%>
                    	<%if(!String.valueOf(ht.get("TM")).equals("1")){%><br>(잔액)<%}%>
                    </td>
                    <td width='7%' align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SCD_AMT")))%></td>
                    <td width='7%' align="right"><input type="text" name="save_amt" size="10" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SAVE_AMT")))%>" class=num onBlur='javascript:this.value=parseDecimal(this.value); setScdSaveAmt(<%=i%>)'></td>
                    <td width='7%' align="right"><input type="text" name="incom_amt" size="10" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%>" class=num onBlur='javascript:this.value=parseDecimal(this.value); setScdSaveAmt(<%=i%>)'></td>
                    <td width='5%' align="right"><input type="text" name="m_amt" size="7" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("M_AMT")))%>" class=num onBlur='javascript:this.value=parseDecimal(this.value); setScdSaveAmt(<%=i%>)'></td>
                    <td width='65%' class="line">
                    	<%if(vt_size3 == 0){%>
                    	<input type='hidden' name='serial' value=''>
                    	<input type='hidden' name='save_per_chk' value=''>
                    	<input type='hidden' name='ven_name' value=''>
                    	<input type='hidden' name='base_amt' value=''>
                    	<input type='hidden' name='save_per' value=''>
                    	<input type='hidden' name='base_save_amt' value=''>
                    	<%}%>
                    	<%if(vt_size3 > 0){%>
                    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                        <tr>
                            <td width='4%' align="center">연번</td>
                            <td width='22%' align="center">사용처</td>
                            <td width='45%' align="center">내용</td>
                            <td width='12%' align="center">사용금액</td>
                            <td width='6%' align="center">적립율</td>
                            <td width='11%' align="center">적립금액</td>
                        </tr>
				            	<%  total_amt5 = 0;
				            	    total_amt6 = 0;
				            			for (int j = 0 ; j < vt_size3 ; j++){
					                  Hashtable ht2 = (Hashtable)vt3.elementAt(j);
					                  int save_per_chk =0;
					            			if(vt_size2 > 0){
				            					for (int k = 0 ; k < vt_size2 ; k++){
					            					Hashtable s_ht = (Hashtable)vt2.elementAt(k);
					            					if(String.valueOf(ht2.get("VEN_NAME")).equals(String.valueOf(s_ht.get("VEN_NAME"))) && !String.valueOf(ht2.get("SAVE_PER")).equals(String.valueOf(s_ht.get("SAVE_PER")))){
					            						save_per_chk++; 
					            						save_per_chk_h++;
					            					}
					            				}
					            			}
					            			total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht2.get("BASE_AMT")));
					            			total_amt6 = total_amt6 + AddUtil.parseLong(String.valueOf(ht2.get("SAVE_AMT")));
					            			total_amt7 = total_amt7 + AddUtil.parseLong(String.valueOf(ht2.get("BASE_AMT")));
					            			total_amt8 = total_amt8 + AddUtil.parseLong(String.valueOf(ht2.get("SAVE_AMT")));
					            %>
                      <tr>
                          <td width='4%' align="center">(<%=j+1%>)<input type='hidden' name='serial' value='<%=ht2.get("SERIAL")%>'><input type='hidden' name='save_per_chk' value='<%=save_per_chk%>'></td>
                          <td width='22%' align="center"><input type="text" name="ven_name" size="30" value="<%=ht2.get("VEN_NAME")%>" class=text onBlur='javascript:setVenSaveAmt(<%=count%>)'></td>
                          <td width='45%'><%=ht2.get("BASE_BIGO")%></td>
                          <td width='12%' align="right"><input type="text" name="base_amt" size="12" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht2.get("BASE_AMT")))%>" class=num onBlur='javascript:this.value=parseDecimal(this.value); setSaveAmt(<%=count%>)'>원</td>
                          <td width='6%' align="right">
                          	<%if(save_per_chk > 0){%><img src=/acar/images/top_arrow.gif align=absmiddle><%}%>
                          	<input type="text" name="save_per" size="2" value="<%=ht2.get("SAVE_PER")%>" class=num onBlur='javascript:setSaveAmt(<%=count%>)'>%</td>
                          <td width='11%' align="right"><input type="text" name="base_save_amt" size="10" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht2.get("SAVE_AMT")))%>" class=num onBlur='javascript:this.value=parseDecimal(this.value); setTotAmt()'>원</td>
                      </tr>
					            <%		count++;
					            		}%>
                      <tr>
                          <td class='is'colspan='3' align="center">합계</td>
                          <td class='is' align="right"><input type="text" name="t_base_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt5)%>" class=whitenum>원</td>
                          <td class='is'>&nbsp;</td>
                          <td class='is' align="right"><input type="text" name="t_base_save_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt6)%>" class=whitenum>원</td>
                      </tr>
					            </table>
					            <%}else{%>
					            &nbsp;
					            <input type='hidden' name='t_base_amt' value=''>
                    	<input type='hidden' name='t_base_save_amt' value=''>
					            <%}%>
                    </td>
                </tr>
                <tr><td colspan='7' class=h></td></tr>  
		            <%	}%>
		            <%}%>
            </table>
	    </td>
    </tr> 	  
    <tr><td class=h></td></tr>  
    <tr> 
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>		            
                <%if(vt_size > 0){%>	        	
                <tr>
                    <td width='9%' class='title'>합계</td>
                    <td width='7%' align="right"><input type="text" name="t_scd_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt3)%>" class=whitenum></td>
                    <td width='7%' align="right"><input type="text" name="t_save_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt4)%>" class=whitenum></td>
                    <td width='7%' align="right"><input type="text" name="t_incom_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt1)%>" class=whitenum></td>
                    <td width='5%' align="right"><input type="text" name="t_m_amt" size="7" value="<%=AddUtil.parseDecimalLong(total_amt2)%>" class=whitenum></td>
                    <td width='65%' class="line">
                    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                        <tr>
                          <td width='71%'>&nbsp;</td>
                          <td width='12%' align="right"><input type="text" name="tt_base_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt7)%>" class=whitenum>원</td>
                          <td width='6%'>&nbsp;</td>
                          <td width='11%' align="right"><input type="text" name="tt_base_save_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt8)%>" class=whitenum>원</td>
                        </tr>
                      </table>  
                    </td>
                </tr>		
                <tr>
                    <td width='9%' class='title'>원래</td>
                    <td width='7%' align="right">&nbsp;</td>
                    <td width='7%' align="right"><input type="text" name="o_save_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt4)%>" class=whitenum>
                    	<br><input type="text" name="c_save_amt" size="12" value="0" class=whitenum>
                    </td>
                    <td width='7%' align="right"><input type="text" name="o_incom_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt1)%>" class=whitenum>
                    	<br><input type="text" name="c_incom_amt" size="12" value="0" class=whitenum>	
                    </td>
                    <td width='5%' align="right"><input type="text" name="o_m_amt" size="7" value="<%=AddUtil.parseDecimalLong(total_amt2)%>" class=whitenum>
                    	<br><input type="text" name="c_m_amt" size="7" value="0" class=whitenum>
                    </td>

                    <td width='65%' class="line">
                    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                        <tr>
                          <td width='89%'>차액</td>
                          <td width='11%' align="right"><input type="text" name="c_base_save_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt4-total_amt8)%>" class=whitenum>원
                          	<br>&nbsp;
                          </td>
                        </tr>
                      </table>  
                    </td>
                </tr>	                            
		            <%}else{%>
                <tr>
                    <td align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr> 	  
    <tr> 
        <td>※ 카드사용취소일 경우에는 사용금액을 0으로 수정하면 됩니다.</td>
    </tr>        
    <tr> 
      <td align="right">
      	<a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
        &nbsp;&nbsp;&nbsp;
	      <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>    
  </table>
  <table border="0" cellspacing="0" cellpadding="0" width=600>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사용처별 적립율 현황</span>
          <%if(vt_size2 > 0){%>
          <%	if(save_per_chk_h > 0){%>
                &nbsp;&nbsp;&nbsp;
                <input type="button" class="button" id="all_auto" value='일괄적용' onclick="javascript:all_chk_saveper();">
                (사용현항의 적립율이 사용처별 적립율과 다릅니다.<img src=/acar/images/top_arrow.gif align=absmiddle>표시분)
          <%	}else{%>
                &nbsp;&nbsp;&nbsp;
                <input type="button" class="button" id="all_auto" value='일괄적용' onclick="javascript:all_auto_saveper();">
                (사용현항의 동일한 사용처에 사용처별적립율 적용)
          <%	}%>
          <%}%>
	    </td>
	  </tr>  	
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='20%' class='title'>연번</td>
                    <td width='50%' class='title'>사용처</td>
                    <td width='30%' class='title'>적립율</td>
                </tr>
                <%if(vt_size2 > 0){
				            for (int i = 0 ; i < vt_size2 ; i++){
					            Hashtable ht = (Hashtable)vt2.elementAt(i);
					      %>
                <tr>
                    <td align="center"><%=i+1%><input type='hidden' name='s_ven_name' value='<%=ht.get("VEN_NAME")%>'></td>
                    <td>&nbsp;<%=ht.get("VEN_NAME")%></td>
                    <td align="center"><input type="text" name="s_save_per" size="2" value="<%=ht.get("SAVE_PER")%>" class=num onBlur='javascript:setCompSave(<%=i%>)'>%</td>
                </tr>
		            <%	}%>
		            <%}else{%>
                <tr>
                    <td colspan="3" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>     
  </table>
<input type='hidden' name='count' value='<%=count%>'>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
