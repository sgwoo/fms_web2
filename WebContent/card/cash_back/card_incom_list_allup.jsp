<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String scd_dt = request.getParameter("scd_dt")==null?"":request.getParameter("scd_dt");
	String s_dt 	= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	
	String s_scd_dt = request.getParameter("s_scd_dt")==null?"":request.getParameter("s_scd_dt");
	String e_scd_dt = request.getParameter("e_scd_dt")==null?"":request.getParameter("e_scd_dt");
	
	Vector vt = CardDb.getCardIncomListAll(s_dt, scd_dt, card_kind, s_scd_dt, e_scd_dt);
	int vt_size = vt.size();	
	
	Vector vt2 = CardDb.getCardSaveList(card_kind);
	int vt_size2 = vt2.size();	

	long total_amt1 = 0;
	long total_amt2 = 0;
	
	int save_per_chk_h = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
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
			fm.action='card_incom_list_allup_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	
	function setTotAmt(){
		var fm = document.form1;
		var t_b_amt = 0;
		var t_s_amt = 0;
		for(var i = 0 ; i < <%=vt_size%> ; i++){
			if(<%=vt_size%>==1){
				t_b_amt = t_b_amt + toInt(parseDigit(fm.base_amt.value));
				t_s_amt = t_s_amt + toInt(parseDigit(fm.save_amt.value));
			}else{
				t_b_amt = t_b_amt + toInt(parseDigit(fm.base_amt[i].value));
				t_s_amt = t_s_amt + toInt(parseDigit(fm.save_amt[i].value));
			}
		}
		fm.t_base_amt.value = parseDecimal(t_b_amt);
		fm.t_save_amt.value = parseDecimal(t_s_amt);
	}

	function setSaveAmt(idx){
		var fm = document.form1;
		if(<%=vt_size%>==1){
			fm.save_amt.value = parseDecimal( toInt(parseDigit(fm.base_amt.value)) * toFloat(fm.save_per.value) /100 ); 
		}else{
			fm.save_amt[idx].value = parseDecimal( toInt(parseDigit(fm.base_amt[idx].value)) * toFloat(fm.save_per[idx].value) /100 ); 
		}
		setTotAmt();
	}
	
	function setVenSaveAmt(idx){
		var fm = document.form1;
		for(var i = 0 ; i < <%=vt_size2%> ; i++){
			if(<%=vt_size%>==1){
				if(fm.s_ven_name[i].value == fm.ven_name.value){
					fm.save_per.value = fm.s_save_per[i].value; 
					fm.save_amt.value = parseDecimal( toInt(parseDigit(fm.base_amt.value)) * toFloat(fm.save_per.value) /100 ); 
				}
			}else{
				if(fm.s_ven_name[i].value == fm.ven_name[idx].value){
					fm.save_per[idx].value = fm.s_save_per[i].value; 
					fm.save_amt[idx].value = parseDecimal( toInt(parseDigit(fm.base_amt[idx].value)) * toFloat(fm.save_per[idx].value) /100 ); 
				}
			}
		}
		setTotAmt();
	}
	
	function all_chk_saveper(){
		var fm = document.form1;
		for(var i = 0 ; i < <%=vt_size%> ; i++){
			if(<%=vt_size%>==1){
				if(fm.save_per_chk.value == '1'){
					for(var j = 0 ; j < <%=vt_size2%> ; j++){
						if(fm.s_ven_name[j].value == fm.ven_name.value){
							fm.save_per.value = fm.s_save_per[j].value; 
							fm.save_amt.value = parseDecimal( toInt(parseDigit(fm.base_amt.value)) * toFloat(fm.save_per.value) /100 ); 
						}
					}
				}
			}else{
				if(fm.save_per_chk[i].value == '1'){
					for(var j = 0 ; j < <%=vt_size2%> ; j++){
						if(fm.s_ven_name[j].value == fm.ven_name[i].value){
							fm.save_per[i].value = fm.s_save_per[j].value; 
							fm.save_amt[i].value = parseDecimal( toInt(parseDigit(fm.base_amt[i].value)) * toFloat(fm.save_per[i].value) /100 ); 
						}
					}
				}
			}
		}
		setTotAmt();
	}
	
	function all_auto_saveper(){
		var fm = document.form1;
		for(var i = 0 ; i < <%=vt_size%> ; i++){
			if(<%=vt_size%>==1){
				for(var j = 0 ; j < <%=vt_size2%> ; j++){
					if(fm.s_ven_name[j].value == fm.ven_name.value){
						fm.save_per.value = fm.s_save_per[j].value; 
						fm.save_amt.value = parseDecimal( toInt(parseDigit(fm.base_amt.value)) * toFloat(fm.save_per.value) /100 ); 
					}
				}
			}else{
				for(var j = 0 ; j < <%=vt_size2%> ; j++){
					if(fm.s_ven_name[j].value == fm.ven_name[i].value){
						fm.save_per[i].value = fm.s_save_per[j].value; 
						fm.save_amt[i].value = parseDecimal( toInt(parseDigit(fm.base_amt[i].value)) * toFloat(fm.save_per[i].value) /100 ); 
					}
				}
			}	
		}
		setTotAmt();
	}	
	
	function all_auto_saveper_acct_code(){
		var fm = document.form1;
		for(var i = 0 ; i < <%=vt_size%> ; i++){
			if(<%=vt_size%>==1){
				if(fm.s_acct_code.value == fm.acct_code.value){
					fm.save_per.value = fm.s_acct_code_save_per.value; 
					fm.save_amt.value = parseDecimal( toInt(parseDigit(fm.base_amt.value)) * toFloat(fm.save_per.value) /100 ); 
				}
			}else{
				if(fm.s_acct_code.value == fm.acct_code[i].value){
					fm.save_per[i].value = fm.s_acct_code_save_per.value; 
					fm.save_amt[i].value = parseDecimal( toInt(parseDigit(fm.base_amt[i].value)) * toFloat(fm.save_per[i].value) /100 ); 
				}
			}
		}
		setTotAmt();
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='scd_dt' value='<%=scd_dt%>'>
<input type='hidden' name='s_dt' value='<%=s_dt%>'>
<input type='hidden' name='s_scd_dt' value='<%=s_scd_dt%>'>
<input type='hidden' name='e_scd_dt' value='<%=e_scd_dt%>'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
<input type='hidden' name='size' value='<%=vt_size%>'>
<input type='hidden' name='size2' value='<%=vt_size2%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=c_db.getNameByIdCode("0031", card_kind, "")%> 예정일:<%=AddUtil.ChangeDate2(s_dt)%> 사용현항</span></td>
	  </tr>
	  <%if(vt_size>1500){%>
    <tr>
	    <td><%=vt_size%>건입니다. 전산처리 가능일자는 최대1500건 입니다. </td>
	  </tr>
	  <%}%>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='3%' class='title'>연번</td>
                    <td width='6%' class='title'>사용일자</td>
                    <td width='11%' class='title'>카드NO</td>
                    <td width='8%' class='title'>사용구분</td>
                    <td width='14%' class='title'>사용처</td>
                    <td width='34%' class='title'>적요</td>
                    <td width='10%' class='title'>사용금액</td>
                    <td width='5%' class='title'>적립율</td>
                    <td width='9%' class='title'>적립금액</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));
					            total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("SAVE_AMT")));
					            int save_per_chk =0;
					            if(vt_size2 > 0){
				            		for (int j = 0 ; j < vt_size2 ; j++){
					            		Hashtable s_ht = (Hashtable)vt2.elementAt(j);
					            		if(String.valueOf(ht.get("VEN_NAME")).equals(String.valueOf(s_ht.get("VEN_NAME"))) && !String.valueOf(ht.get("SAVE_PER")).equals(String.valueOf(s_ht.get("SAVE_PER")))){
					            			save_per_chk++; 
					            			save_per_chk_h++;
					            		}
					            	}
					            }
					      %>
				
				<%if(gubun1.equals("4")){%>	      
                <tr id=tr_h style="display:<%if(String.valueOf(ht.get("ACCT_CODE")).equals("00004") && String.valueOf(ht.get("BASE_BIGO")).indexOf("아마존탁송") == -1){%>''<%}else{%>none<%}%>">
                <%}else{%>
                <tr>
                <%} %>
                    <td align="center"><%=i+1%><input type='hidden' name='serial' value='<%=ht.get("SERIAL")%>'><input type='hidden' name='save_per_chk' value='<%=save_per_chk%>'></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>
                    <td align="center"><%=ht.get("CARDNO")%></td>
                    <td align="center"><%=ht.get("BASE_G")%></td>
                    <td>&nbsp;<input type="text" name="ven_name" size="25" value="<%=ht.get("VEN_NAME")%>" class=text onBlur='javascript:setVenSaveAmt(<%=i%>)'></td>
                    <td>&nbsp;<%=ht.get("BASE_BIGO")%></td>
                    <td align="right"><input type="text" name="base_amt" size="12" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%>" class=num onBlur='javascript:this.value=parseDecimal(this.value); setSaveAmt(<%=i%>)'>원</td>
                    <td align="right">
                    	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) && String.valueOf(ht.get("ACCT_CODE")).equals("00004")){%>차량유류대<%}%>
                    	<input type='hidden' name='acct_code' value='<%=ht.get("ACCT_CODE")%>'>
                    	<%if(save_per_chk > 0){%><img src=/acar/images/top_arrow.gif align=absmiddle><%}%>
                    	<input type="text" name="save_per" size="2" value="<%=ht.get("SAVE_PER")%>" class=num onBlur='javascript:setSaveAmt(<%=i%>)'>%</td>
                    <td align="right"><input type="text" name="save_amt" size="10" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SAVE_AMT")))%>" class=num onBlur='javascript:this.value=parseDecimal(this.value); setTotAmt()'>원</td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' colspan='6'>합계</td>
                    <td align="right"><input type="text" name="t_base_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt1)%>" class=whitenum>원</td>
                    <td>&nbsp;</td>
                    <td align="right"><input type="text" name="t_save_amt" size="10" value="<%=AddUtil.parseDecimalLong(total_amt2)%>" class=whitenum>원</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="9" align="center">등록된 데이타가 없습니다.</td>
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
  <table border="0" cellspacing="0" cellpadding="0" width=700>
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
    <%if(vt_size2 > 0){%>
    <tr>
        <td>    
          <input type="checkbox" name="save_cng_yn" value="Y"> 사용처별 적립율을 위 데이타로 갱신한다.
	    </td>
    </tr> 
    <%}%>
    <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계정코드별 일괄처리</span>
	    	  계정코드 : <input type="text" name="s_acct_code" size="4" value="" class=text>
	    	  적립율 : <input type="text" name="s_acct_code_save_per" size="4" value="" class=text>
	    	  <input type="button" class="button" id="all_auto" value='일괄적용' onclick="javascript:all_auto_saveper_acct_code();">
          (사용현항의 동일한 계정코드에 적립율 일괄적용)
	    </td>
	  </tr>  	
    <%}%>
    
  </table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
