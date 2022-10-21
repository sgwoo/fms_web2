<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%	
	if(!st_dt.equals("") && end_dt.equals("")) end_dt = st_dt;
	
	Vector vts = IssueDb.getIssue1TaxList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}	
			}
		}
		return;
	}	
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<input type='hidden' name='reg_st' value=''>
<input type='hidden' name='reg_gu' value=''>
<input type='hidden' name='tax_out_dt' value=''>
<input type='hidden' name='mail_auto_yn' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='1170'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>
	  <td class='line' width='530' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>	    	
          <tr> 
            <td width='40' class='title'>����</td>
            <td width='40' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
            <td width='100' class='title'>�Ϸù�ȣ</td>			
            <td width='150' class='title'>��ȣ</td>			
            <td width='150' class='title'>���</td>			
            <td width='50' class='title'>�Ǽ�</td>			
          </tr>
        </table>
    </td>
	  <td class='line' width='640'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='100' class='title'>���ް�</td>
            <td width='100' class='title'>�ΰ���</td>
            <td width='100' class='title'>�հ�</td>			
            <td width='100' class='title'>�ŷ���������</td>
            <td width='100' class='title'>���ݰ�꼭����</td>
            <td width='70' class='title'>��û���Ǽ�</td>			
			      <td width='70' class='title'>�����Ǽ�</td>			
          </tr>
      </table>
	  </td>
  </tr>
  <%	if(vt_size > 0){%>
  <tr>
	  <td class='line' width='530' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='40' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
            <td width='40' align='center'>
			        <%if(String.valueOf(ht.get("STOP_CNT")).equals("0") && String.valueOf(ht.get("CLS_CNT")).equals("0")){%>
			        <input type="checkbox" name="ch_l_cd" value="<%=ht.get("ITEM_ID")%>">
			        <input type='hidden'   name="h_l_cd"  value="<%=ht.get("ITEM_ID")%>">
			        <%}%>
			      </td>
			      <td width='100' align='center'><a href="javascript:parent.ViewTaxItem('<%=ht.get("ITEM_ID")%>')"><%=ht.get("ITEM_ID")%></a></td>
            <td width='150' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></span></td>			
            <td width='150' align='center'><%=ht.get("RM_ST")%>
                <%if(String.valueOf(ht.get("RM_ST")).equals("")){%>
                <span title='<%=ht.get("TAX_BIGO")%>'><%=AddUtil.subData(String.valueOf(ht.get("TAX_BIGO")), 10)%></span>
                <%}else{%>
                <span title='<%=ht.get("TAX_BIGO")%>'><%=AddUtil.subData(String.valueOf(ht.get("TAX_BIGO")), 6)%></span>
                <%}%>
            </td>                
            <td width='50' align='center'><%=ht.get("CNT")%>��</td>
          </tr>
          <%}%>
        </table>
    </td>
	  <td class='line' width='640'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='100' align="right" ><%=AddUtil.parseDecimal(String.valueOf(ht.get("ITEM_SUPPLY")))%>��&nbsp;</td>
            <td width='100' align="right" ><%=AddUtil.parseDecimal(String.valueOf(ht.get("ITEM_VALUE")))%>��&nbsp;</td>
            <td width='100' align="right" ><%=AddUtil.parseDecimal(String.valueOf(ht.get("ITEM_HAP_NUM")))%>��&nbsp;</td>
            <td width='100' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%></td>
            <td width='100' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_EST_DT")))%></td>			
            <td width='70' align="center"><%=ht.get("CLS_CNT")%>��</td>						
			      <td width='70' align="center"><%=ht.get("STOP_CNT")%>��</td>
          </tr>
          <%}%>
      </table>
	  </td>
  </tr>
  <%	}else{%>                     
  <tr>
	  <td class='line' width='530' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
          </tr>
      </table>
    </td>
	  <td class='line' width='640'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		        <td>&nbsp;</td>
		      </tr>
	    </table>
	  </td>
  </tr>
  <% 	}%>
</table>
</form>
</body>
</html>
