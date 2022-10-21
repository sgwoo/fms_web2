<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.user_mng.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "09");
	
	int cnt = 3; //현황 출력 영업소 총수
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-240;//현황 라인수만큼 제한 아이프레임 사이즈
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//전체출력
	function all_tax(){
	
		var fm = inner.document.form1;	
		fm.reg_st.value = "all";
		fm.reg_gu.value = "1";
		fm.mail_auto_yn.value = document.form1.mail_auto_yn.value;
		
		if(confirm('세금계산서일자가 오늘보다 크면 발행되지 않습니다.')){				
		if(confirm('계산서를 선택 발행하시겠습니까?')){
			fm.target = "_blank";
			fm.action = "tax_reg_step1.jsp";
			fm.submit();	
		
			fm.tax_out_dt.value = '';									
		}}
	}
	
	//선택출력
	function select_tax(){
		
		var fm = inner.document.form1;	
		fm.reg_st.value = "select";				
		fm.reg_gu.value = "1";		
		fm.mail_auto_yn.value = document.form1.mail_auto_yn.value;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("세금계산서를 발행할 계약을 선택하세요.");
			return;
		}	
		
		if(confirm('세금계산서일자가 오늘보다 크면 발행되지 않습니다.')){		
		if(confirm('계산서를 선택 발행하시겠습니까?')){		
			fm.target = "_blank";
			fm.action = "tax_reg_step1.jsp";
			fm.submit();	
			
			fm.tax_out_dt.value = '';				
		}}
	}	

	//변경화면
	function cng_taxitem()
	{
		var fm = inner.document.form1;	

		if(document.form1.tax_out_dt.value == ''){ alert('변경할 세금일자를 입력하십시오.'); return; }		
		document.form1.tax_out_dt.value = ChangeDate(document.form1.tax_out_dt.value);		
		
		fm.tax_out_dt.value = document.form1.tax_out_dt.value;
		
		if(confirm('세금계산서일자를 수정하시겠습니까?')){		
			fm.target = "i_no";
			fm.action = "tax_est_dt_cng.jsp";
			fm.submit();
		
			fm.tax_out_dt.value = '';
		}
	}
	
	function ViewTaxItem(item_id){		
		var taxItemInvoice = window.open("about:blank", "TaxItem", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=1200px, height=800px");
		var fm = document.form1;
		fm.item_id.value = item_id;
		fm.target="TaxItem";
		fm.action = "tax_item_u.jsp";
		fm.submit();			
		
		fm.item_id.value = '';
	}					
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='reg_gu' value='1'>
<input type='hidden' name='cng_st' value=''>
<input type='hidden' name='item_id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td>	  
	      <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	      <%	if(nm_db.getWorkAuthUser("회계업무",user_id)){%>
	      			세금계산서일자 : <input type='text' name='tax_out_dt' value='' size='11' class=text onBlur='javscript:this.value = ChangeDate(this.value);'>&nbsp;
	      			<a href="javascript:cng_taxitem();" title='세금일자변경'><img src=/acar/images/center/button_ch_tax.gif border=0 align=absmiddle></a>&nbsp;/&nbsp;	  
	      <%	}%>	  
	      <select name="mail_auto_yn">
          <option value="Y">계산서발행시 메일 자동발송</option>
          <option value="N">계산서발행후 메일 수동발송</option>
        </select>
	      <a href="javascript:select_tax();" title='선택발행'><img src="/acar/images/center/button_stbh.gif" align="absmiddle" border="0"></a>&nbsp;
	      <a href="javascript:all_tax();" title='전체발행'><img src="/acar/images/center/button_jcbh.gif" align="absmiddle" border="0"></a>&nbsp;	     	  
	      <%}%>	  	  
	    </td>
    </tr>  
    <tr> 
      <td height="<%=height%>"><iframe src="issue_1_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td><!--모니터높이 - sh 길이 - 상단메뉴 길이 - (라인수*40)-->
    </tr>  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
