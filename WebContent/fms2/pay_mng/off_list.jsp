<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.pay_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	String off_st 	= request.getParameter("off_st")==null?"":request.getParameter("off_st");
	String off_st_nm= request.getParameter("off_st_nm")==null?"":request.getParameter("off_st_nm");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String vid_size = request.getParameter("vid_size")==null?"":request.getParameter("vid_size");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String way_size = request.getParameter("way_size")==null?"":request.getParameter("way_size");
	
	
	
	auth_rw = rs_db.getAuthRw(ck_acar_id, "05", "12", "10");
	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	t_wd = AddUtil.replace(t_wd,"'","");
	
	//거래처정보
	Vector vt =  ps_db.getOffSearchList(off_st, t_wd);
	int vt_size = vt.size();
	
	//금융사리스트
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
%>

<html>
<head><title>거래처 검색</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function Search(){
		var fm = document.form1;
		fm.action = "off_list.jsp";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') document.form1.submit();
	}

	function setOff(off_id, off_nm, off_idno, ven_code, ven_name, ven_st, bank_id, bank_nm, bank_no, bank_acc_nm, off_tel){
		var mfm = document.form1;
		var fm = opener.document.form1;
		<%if(idx.equals("")){%>
			fm.off_id.value 		= off_id;
			fm.off_nm.value 		= off_nm;	
			fm.off_idno.value 		= off_idno;			
			fm.ven_code.value 		= ven_code;
			fm.ven_name.value 		= ven_name;
			fm.off_tel.value 		= off_tel;				
			if(fm.off_st.value == 'other') 					fm.off_id.value 	= ven_code;
			
			//특정업체 입금계좌 미표시	
			if(off_id == '' && off_nm == '아마존카'){
				fm.bank_id.value 		= '';
				fm.bank_no.value 		= '';		
				fm.bank_acc_nm.value 		= '';						
			//특정업체 입금계좌 미표시	
			}else if( ven_code == '040044' || ven_code == '108905'  || ven_code == '000334' || ven_code == '106984' || ven_code == '000504' || ven_code == '005959' || 
			          ven_code == '005961' || ven_code == '1011141' || ven_code == '000582' || ven_code == '004488' || ven_code == '105783' || ven_code == '006059' || 
			          ven_code == '003939' || ven_code == '001281'  || ven_code == '006208' || ven_code == '607784' || ven_code == '001272' || ven_code == '1235066' || 
			          ven_code == '996045' || ven_code == '996378'  || ven_code == '1257579' || ven_code == '107776'
			        )
			{
				fm.bank_id.value 		= '';
				fm.bank_no.value 		= '';		
				fm.bank_acc_nm.value 		= '';		
				
				if( ven_code == '996378'){ //광주카드(3개월 국세납부)는 자동이체
					<%if(way_size.equals("1")){%>
					<%}else{%>
						fm.p_way[3].checked = true;
					<%}%>	
				}
			}else if (ven_code == '120698'){ //인천계양구청(취등록지방세)는 자동이체
				<%if(way_size.equals("1")){%>
				<%}else{%>
					fm.p_way[3].checked = true;
				<%}%>				
				fm.bank_id.value 		= '';
				fm.bank_no.value 		= '';		
				fm.bank_acc_nm.value 	= '';
				fm.deposit_no.value 	= '140-004-023871'; //출금계좌
				ven_st = '3';
				
			}else{
				fm.bank_id.value 		= bank_id;
				fm.bank_no.value 		= bank_no;		
				fm.bank_acc_nm.value 		= bank_acc_nm;		
				<%for(int i = 0 ; i < bank_size ; i++){
					Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);%>
					if('<%= bank_ht.get("NM")%>' == bank_nm) 		fm.s_bank_id.value = '<%= bank_ht.get("BANK_ID")%>';
					if('<%= bank_ht.get("BANK_ID")%>' == bank_id) 		fm.s_bank_id.value = '<%= bank_ht.get("BANK_ID")%>';
        			<%}%>
			}
					
			if(ven_st != ''){
				fm.ven_st[0].checked = false;
				fm.ven_st[1].checked = false;
				fm.ven_st[2].checked = false;
				fm.ven_st[3].checked = false;
				fm.ven_st[4].checked = false;		
				if(ven_st == '1')		fm.ven_st[0].checked = true;
				else if(ven_st == '2')	fm.ven_st[1].checked = true;
				else if(ven_st == '3')	fm.ven_st[2].checked = true;
				else if(ven_st == '4')	fm.ven_st[3].checked = true;						
				else                    fm.ven_st[4].checked = true;						
			}
		<%}else{%>
			<%if(AddUtil.parseInt(vid_size) == 1){%>	
			fm.off_id.value 		= off_id;
			fm.off_nm.value 		= off_nm;	
			fm.s_idno.value 		= off_idno;			
			fm.ven_code.value 		= ven_code;
			fm.ven_name.value 		= ven_name;
			fm.off_tel.value 		= off_tel;
			if(off_id == '' && off_nm == '아마존카'){
				fm.bank_id.value 	= '';
				fm.bank_no.value 	= '';
				fm.bank_nm.value 	= '';		
				fm.bank_acc_nm.value 	= '';					
			}else{
				fm.bank_id.value 	= bank_id;
				fm.bank_no.value 	= bank_no;
				fm.bank_nm.value 	= bank_nm;		
				fm.bank_acc_nm.value 	= bank_acc_nm;					
			}
			<%}else if(AddUtil.parseInt(vid_size) > 1){%>	
			fm.off_id[<%=idx%>].value 	= off_id;
			fm.off_nm[<%=idx%>].value 	= off_nm;	
			fm.s_idno[<%=idx%>].value 	= off_idno;			
			fm.ven_code[<%=idx%>].value 	= ven_code;
			fm.ven_name[<%=idx%>].value 	= ven_name;
			fm.off_tel[<%=idx%>].value 	= off_tel;			
			if(off_id == '' && off_nm == '아마존카'){
				fm.bank_id[<%=idx%>].value 	= '';
				fm.bank_no[<%=idx%>].value 	= '';
				fm.bank_nm[<%=idx%>].value 	= '';		
				fm.bank_acc_nm[<%=idx%>].value 	= '';		
			}else{
				fm.bank_id[<%=idx%>].value 	= bank_id;
				fm.bank_no[<%=idx%>].value 	= bank_no;
				fm.bank_nm[<%=idx%>].value 	= bank_nm;		
				fm.bank_acc_nm[<%=idx%>].value 	= bank_acc_nm;		
			}
			<%}%>
			
		<%}%>

		window.close();
	}
	
	//네오엠 거래처 등록하기
	function Save(){
		var fm = document.form1;
		fm.action = "/card/doc_reg/vendor_reg.jsp";
		fm.submit();
	}	
	
	//협력업체 등록하기
	function serv_off_reg(){
		var SUBWIN = "/acar/cus0601/cus0601_d_cont_i.jsp?auth_rw=6&from_page=/fms2/pay_mng/off_list.jsp";
		window.open(SUBWIN, "ServOffReg", "left=100, top=120, width=920, height=425, scrollbars=auto");
	}	
	
	//관공서 등록하기
	function fine_off_reg(){
		var SUBWIN = "/acar/fine_gov/fine_gov_i.jsp?auth_rw=6&from_page=/fms2/pay_mng/off_list.jsp";
		window.open(SUBWIN, "REG_FINE_GOV", "left=100, top=120, width=920, height=450, scrollbars=auto");
	}				
	
	//네오엠 거래처 수정하기
	function Update(off_id, ven_code){
		var fm = document.form1;
		fm.off_id.value = off_id;
		fm.ven_code.value = ven_code;		
		fm.action = "/card/doc_reg/vendor_upd.jsp";
		fm.submit();
	}	
	
	//협력업체 수정하기
	function serv_off_update(off_id, ven_code){
		var SUBWIN = "/acar/cus0601/cus0601_d_cont_u.jsp?auth_rw=6&from_page=/fms2/pay_mng/off_list.jsp&off_id="+off_id;
		window.open(SUBWIN, "ServOffReg", "left=100, top=120, width=1220, height=425, scrollbars=auto");
	}	
	
	//관공서 수정하기
	function fine_off_update(off_id, ven_code){
		var SUBWIN = "/acar/fine_gov/fine_gov_i.jsp?auth_rw=6&from_page=/fms2/pay_mng/off_list.jsp&gov_id="+off_id;
		window.open(SUBWIN, "REG_FINE_GOV", "left=100, top=120, width=920, height=450, scrollbars=auto");
	}				
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' action='off_list.jsp'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='off_st' value='<%=off_st%>'>
<input type='hidden' name='off_st_nm' value='<%=off_st_nm%>'>
<input type='hidden' name='vid_size' value='<%=vid_size%>'>
<input type='hidden' name='way_size' value='<%=way_size%>'>
<input type='hidden' name='ven_code' value=''>
<input type='hidden' name='ven_name' value=''>
<input type='hidden' name='off_id' value=''>
<input type='hidden' name='off_nm' value=''>
<input type='hidden' name='off_idno' value=''>
<input type='hidden' name='go_url' value='/fms2/pay_mng/off_list.jsp'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td align='left'>
      &nbsp;&nbsp;<img src=/acar/images/center/arrow_glc.gif align=absmiddle>&nbsp;
        <input type='text' name='t_wd' size='30' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>

        &nbsp;<a href="javascript:document.form1.submit()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
		&nbsp;&nbsp;
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='3%' rowspan="2" class='title'>연번</td>
            <td width="8%" rowspan="2" class='title'>구분</td>			
            <td colspan="3" class='title'>지출처</td>						
            <td colspan="5" class='title'>네오엠 거래처 </td>						
            <td width="5%" rowspan="2" class='title'>수정</td>						
            <!--<td width="6%" rowspan="2" class='title'>이력</td>-->
          </tr>
          <tr>
            <td width="5%" class='title'>코드</td>
            <td width="20%" class='title'>이름</td>
            <td width="5%" class='title'>대표자</td>			
            <td width="5%" class='title'>코드</td>
            <td width="15%" class='title'>이름</td>
            <td width="7%" class='title'>과세유형</td>
            <td width="8%" class='title'>사업자번호</td>
            <td width="19%" class='title'>주소</td>
          </tr>
                <%if(vt_size > 0 && !t_wd.equals("")){
						for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							String ven_st  	= String.valueOf(ht.get("VEN_ST"));
							String ven_code	= String.valueOf(ht.get("VEN_CODE"));
							String ven_name	= String.valueOf(ht.get("VEN_NAME"));
							String s_idno 	= String.valueOf(ht.get("OFF_IDNO"));
							if(ven_code.equals("") && !s_idno.equals("")){
								Hashtable vendor = neoe_db.getVendorCaseS(ven_code, s_idno);
								ven_code = String.valueOf(vendor.get("VEN_CODE"));
								ven_name = String.valueOf(vendor.get("VEN_NAME"));
							}
				%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%=off_st_nm%></td>			
            <td align="center"><%=ht.get("OFF_ID")%></td>						
            <td align="center"><a href="javascript:setOff('<%=ht.get("OFF_ID")%>','<%=ht.get("OFF_NM")%>','<%=ht.get("OFF_IDNO")%>','<%=ven_code%>','<%=ven_name%>','<%=ht.get("VEN_ST")%>','<%=ht.get("BANK_ID")%>','<%=ht.get("BANK_NM")%>','<%=ht.get("BANK_NO")%>','<%=ht.get("BANK_ACC_NM")%>','<%=ht.get("OFF_TEL")%>');"><%=ht.get("OFF_NM")%></a></td>
            <td align="center"><%=ht.get("OWN_NM")%></td>									
            <td align="center"><%=ven_code%></td>
            <td align="center"><%=ven_name%></td>
            <td align="center">
              <%if(ven_st.equals("1")){%>
              일반과세
              <%}else if(ven_st.equals("2")){%>
              간이과세
              <%}else if(ven_st.equals("3")){%>
              면세
              <%}else if(ven_st.equals("4")){%>
              비영리법인(국가기관/단체)
              <%}else{%>
            	<%}%>
            </td>            
            <td align="center"><%=ht.get("OFF_IDNO")%></td>
            <td>&nbsp;<%=ht.get("VEN_ADDR")%></td>			
            <td align="center">
	    	  <%if(off_st.equals("off_id")){%>
	    	  <a href="javascript:serv_off_update('<%=ht.get("OFF_ID")%>','<%=ht.get("VEN_CODE")%>');"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
	    	  <%}else if(off_st.equals("gov_id")){%>
	    	  <a href="javascript:fine_off_update('<%=ht.get("OFF_ID")%>','<%=ht.get("VEN_CODE")%>');"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
	    	  <%}else if(off_st.equals("other")){%>
	    	  <a href="javascript:Update('<%=ht.get("OFF_ID")%>','<%=ht.get("VEN_CODE")%>');"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
			  <%}%>			
			</td>            			
          </tr>
                <%	}
				}%>		  
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td align='right'>
	    <%if(off_st.equals("off_id")){%>
	    <a href="javascript:serv_off_reg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}else if(off_st.equals("gov_id")){%>
	    <a href="javascript:fine_off_reg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}else if(off_st.equals("other")){%>
	    <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp; 
		<%}%>
      	<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
     <tr> 
      <td align='left'>&nbsp;&nbsp;&nbsp;<font color=red>※ 상호가 같은 경우 사업자번호를 반드시 확인하셔서 정확하게 입력하셔야 합니다. <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;부가세 신고 등 회계처리와 관련이 있습니다.</font> 
     </td>
    </tr>
  </table>
</form>
</body>
</html>