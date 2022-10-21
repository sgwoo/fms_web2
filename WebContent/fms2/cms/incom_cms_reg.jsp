<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int count = 0;

	//jip_cms 테이블에서 입금반영된 출금의뢰일 조회하기
	Vector vt2 = ad_db.getAJipCmsDate();
	int vt_size2 = vt2.size();

  String ip_addr = request.getRemoteAddr();
	
//	out.println(ip_addr.substring(0,10));	
	
	//출금건수	
	
//	String e = StringCrypto.encrypt("SSN", "1288147957");
//	out.println(e);
//	String d = StringCrypto.decrypt("SSN", e);
//	out.println(d);
 				
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//수정
	function incomCms(){
		var theForm = document.form1;
		
		
		if(theForm.cms_cnt.value != '1'){ alert("출금의뢰일자오류입니다.  전산실에 문의하세요!"); return; }
		if(theForm.org_code.value == ''){ alert("기관코드를 확인하세요!"); return; }
		if(theForm.incom_dt.value == ''){ alert("통장입금일자를 확인하세요!"); return; }
		if(theForm.incom_amt.value == ''){ alert("통장입금액을 확인하세요!"); return; }
		if(theForm.v_gubun[0].checked == false && theForm.v_gubun[1].checked == false ) 
			{ alert('구분을 선택하십시오.'); return;}	
		
		if(!confirm("집금처리하시겠습니까?"))	return;		
		
		var gsWin = window.open('about:blank','popuptarget','width=500,height=200,top=630,left=530');	
		theForm.action = "/fms2/cms/incom_cms_reg_2.jsp";
		theForm.target ="popuptarget";
		theForm.method ="post";
		theForm.submit();
				
		
	}

		
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
.style8 {color: #0054ff; font-weight: bold;}
.style9 {color: #ff0000; font-weight: bold;}
-->

</style>
</head>
<body>
<center>
<form  name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="cms_cnt" value="<%=vt_size2 %>">

<table border=0 cellspacing=0 cellpadding=0 width=900>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 재무회게 > CMS > <span class=style5>CMS 집금처리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style8>CMS 집금원장처리</span>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=900>
                <tr>			    	
                    <td class=title width=200>출금의뢰일자(EA22)</td>	
                    <td width='600' >&nbsp;
	              <select name="adate">
				    <option value="">선택</option>
	<%		for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);%>
	                <option value="<%=ht.get("ADATE")%>"  ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ADATE")))%></option>
	<%		}%>
	              </select>	
			  </td>		    	
              
	      </tr>
	        <tr>
	             <td class=title width=200>기관코드</td>			    	
                       <td width='600' >&nbsp;
	              <select name="org_code">
				    <option value="">선택</option>
				    <option value="9951572587">9951572587 (신한:amazoncar1)</option>             
			              <option value="9950110252">9950110252 (외환:amazoncar2)</option>              
			                <option value="9954513141">9954513141 (산업:amazoncar3)</option>    
			                <option value="9950110401">9950110401 (전북:amazoncar4)</option>    			                  
			                <option value="9954516981">9954516981 (산업:amazoncar6)</option>     
			                <option value="9954517597">9954517597 (우리:amazoncar7)</option> 
  					<option value="9954519858">9954519858 (광주:amazoncar8)</option> 
 					<option value="9950110418">9950110418 (하나:amazoncar5) (사용x)</option>     
                                                              
	              </select>	
			  </td>		
	   </tr>
	      
	      <tr>
	             <td class=title width=200>통장입금일</td>			    	
                    <td width=600>&nbsp;<input type="text" name="incom_dt"  size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">
	      </tr>
	      <tr>			    	
                    <td class=title width=200>통장입금액</td>			    	
                    <td width=600>&nbsp;<input type="num" name="incom_amt"  size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value);'></td>
     	      </tr>
     	       <tr>			    	
                    <td class=title width=200>구분</td>			    	
                    <td width=600>&nbsp;
                        <input type='radio' name="v_gubun" value='Y' > 최초
                        <input type='radio' name="v_gubun" value='N' >  추가
                    </td>
     	      </tr>
             </table>
            </td>
         </tr>
         <tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><font color=red>* 처리시간이 소요되는 작업입니다.   (104 server) </font></td>
    </tr>
    <% if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  	
   <tr>
	<td align='right'>		
	<a href="javascript:incomCms()"><img src=/acar/images/center/button_reg.gif border=0></a> </td>
  </tr>
  <% } %>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>