<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.inside_bank.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	String bank_code = request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	
	String ven_code 	= request.getParameter("ven_code")==null? "":request.getParameter("ven_code");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
      
	if (t_wd.equals("")) t_wd = AddUtil.getDate(4);
	
		
	int ip_size = 0;
	Vector ips = ib_db.getIbAcctAllTrDdEtcList(s_kd, t_wd, "matching", bank_code , asc);

	ip_size = ips.size();	
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
		

%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	
	//거래처 확인 
	function viewClient(idx){
		var fm = document.form1;
		
		if ( fm.client_id[idx].value != '' ) { 
				window.open("about:blank", "SCDUPD", "left=50, top=50, width=800, height=610, scrollbars=yes");				
				fm.all_cid.value = 	 fm.client_id[idx].value ;
				fm.incom_dt.value = 	 fm.tr_date[idx].value ;
				fm.incom_acct_seq.value = 	 fm.acct_seq[idx].value ;
				fm.incom_tr_date_seq.value = 	 fm.tr_date_seq[idx].value ;
				fm.incom_amt.value = 	 fm.ip_amt[idx].value ;
				fm.incom_naeyong.value = 	 fm.naeyong[idx].value ;
				fm.incom_tr_branch.value = 	 fm.tr_branch[idx].value ;
				fm.incom_bank_nm.value = 	 fm.bank_nm[idx].value ;
				fm.incom_bank_no.value = 	 fm.bank_no[idx].value ;
																			
				fm.action = "erp_client_scd.jsp";
				fm.target = "SCDUPD";
				fm.submit();
							
		} else {
			alert("매칭거래처가 없습니다!!!."); 
		   return;
		}		
	}
	
	
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' >
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='ip_size' value='<%=ip_size%>'> 
<input type='hidden' name='all_cid' > 
<input type='hidden' name='incom_dt' > 
<input type='hidden' name='incom_acct_seq' > 
<input type='hidden' name='incom_tr_date_seq' > 
<input type='hidden' name='incom_naeyong' > 
<input type='hidden' name='incom_tr_branch' > 
<input type='hidden' name='incom_amt' > 
<input type='hidden' name='incom_bank_nm' > 
<input type='hidden' name='incom_bank_no' > 

<table width="100%" border="0" cellspacing="0" cellpadding="0">

	<tr>
		<td colspan=3  class=h></td>
	</tr>	
	    	
    <tr> 
        <td colspan=3 class=line2></td>
    </tr>
    <tr> 
        <td colspan=3 class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr  style='height:45'>
            
                    <td class=title width=4%>연번</td>                                
                    <td class=title width=10%>은행코드</td>
                    <td class=title width=8%>은행명</td>
                    <td class=title width=11%>계좌번호</td>
                    <td class=title width=7%>거래일</td>
                    <td class=title width=3%>순번</td>  
                    <td class=title width=9%>거래지점</td>   
                    <td class=title width=11%>거래내역</td>   
                    <td class=title width=10%>적요</td>   
                    <td class=title width=8%>입금액</td>   
                    <td class=title width=16%>매칭거래처</td>   
                    <td class=title width=3%>적용</td>   
                                
                </tr>
          <%for (int i = 0 ; i < ip_size ; i++){
				Hashtable ht = (Hashtable)ips.elementAt(i);%>
                <tr style='height:30' > 
                   <input type="hidden" name="idx" value="<%=i%>" >
                   <input type="hidden" name="tr_branch" value="<%=ht.get("TRAN_BRANCH")%>" >
                 	<input type="hidden" name="naeyong" value="<%=ht.get("NAEYONG")%>" >
                   	<input type="hidden" name="jukyo" value="<%=ht.get("JUKYO")%>" >
                   	<input type="hidden" name="ipji_gbn" value="<%=ht.get("TR_IPJI_GBN")%>" >
                   	<input type="hidden" name="fms_yn" value="<%=ht.get("ERP_FMS_YN")%>" >
                   	<input type="hidden" name="tr_date" value="<%=String.valueOf(ht.get("TR_DATE")).trim()%>" >
                   	<input type="hidden" name="acct_seq" value="<%=String.valueOf(ht.get("ACCT_SEQ")).trim() %>" >
                   	<input type="hidden" name="tr_date_seq" value="<%=String.valueOf(ht.get("TR_DATE_SEQ")).trim()%>" >
                   	<input type="hidden" name="ip_amt" value="<%=Util.parseDecimal2(String.valueOf(ht.get("IP_AMT")))%>" >	 	 
                   	<input type="hidden" name="bank_nm" value="<%=ht.get("BANK_NM")%>" >
                   	<input type="hidden" name="bank_no" value="<%=ht.get("BANK_NO")%>" >	 	
                   <input type="hidden" name="client_id" >         		
               
                    <td align="center"><%=i+1%></td>                    
                    <td align="center"><%=ht.get("BANK_ID")%>(<%=ht.get("BANK_NM")%>)</td>
                    <td align="center"><%=ht.get("BANK_NAME")%></td>
                    <td align="center"><%=ht.get("ACCT_NB")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TR_DATE")))%></td>
                    <td align="center"><%=ht.get("TR_DATE_SEQ")%></td>
                    <td align="left"><%=ht.get("TRAN_BRANCH")%></td>  
                    <td align="left"><%=ht.get("NAEYONG")%></td>
                    <td align="left"><%=ht.get("JUKYO")%></td> 
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("IP_AMT")))%></td>
                    <td align="left"><input type="text" name="firm_nm" class=whitetext  size=30><div id="results<%=i%>"></div></td>
                    <td align="center"><%=ht.get("ERP_FMS_YN")%></td>  
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;<font color=red>*</font>&nbsp;입금처리할 거래를 선택하세요!!!.</td>
    </tr>	  
     <tr> 
        <td>&nbsp;<font color=red>*</font>&nbsp;최근6개월내 거래지점,거래내역,적요가 같으면서 입금처리가 최소2건이상인 경우에 한해서 거래처가 매칭됩니다.!!!.</td>
    </tr>	    
</table>
</form>
 	 	
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>

<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
		
		var scd_size 	= toInt(fm.ip_size.value);			
	   		    
		for(var i = 0 ; i < scd_size ; i ++){
	
			if ( fm.client_id[i].value != '' ) {			
         	   result = "<a href=javascript:viewClient('"+ i + "') ><img src=/acar/images/center/icon_memo.gif align=absmiddle border=0></a>";        
         	  	document.getElementById('results' + i).innerHTML = result 
	      }
		}
		
 	}
//-->
</script> 	 	 	 	  	
</body>
</html>