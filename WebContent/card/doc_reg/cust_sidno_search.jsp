<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>


<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//거래처정보
	TradeBean[] vens = neoe_db.getBaseTradeSidnoSearchList(s_kd, t_wd, "");//-> neoe_db 변환
	int ven_size = vens.length;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="cust_sidno_search.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
	function Confirm1(){
		var fm = document.form1;
		if(fm.ven_chk.value == '0'){
			opener.form1.<%=s_kd%>_yn.value = 'Y';
		}else{
			opener.form1.<%=s_kd%>_yn.value = 'N';
		}
		window.close();	
	}
	
	function Confirm2(){
		var fm = document.form1;
		opener.form1.<%=s_kd%>_yn.value = 'Y';
		window.close();	
	}	
	
//-->
</script>

</head>
<body>
<form action="./cust_sidno_search.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>  
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">  
  <input type="hidden" name="go_url" value="<%=go_url%>">
  <input type="hidden" name="ven_chk" value="<%=ven_size%>">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>사업자등록번호 중복체크</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td></td></tr>
    <tr><td class=line2></td></tr>  
  <!--
    <tr> 
      <td>&nbsp;&nbsp;
      <img src=/acar/images/center/arrow_num_suj.gif align=absmiddle>&nbsp;      
        <input name="t_wd" type="text" class="text" value="<%=t_wd%>" size="12" onKeyDown="javasript:enter()" style='IME-MODE: active' >
		&nbsp;<a href="javascript:Search();" ><img src=/acar/images/center/button_jbck.gif border=0 align=absmiddle></a>

		</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
	-->
    <tr>
      <td class="line" >
	    <table border="0" cellspacing="2" cellpadding="10" width='100%'>
          <tr>
            <td colspan="3" align="center">
              " <span class="style5"><%=t_wd%></span> " 는(은)<br><br>             
              <%if(ven_size == 0){%>
			  사용 가능한
			  <%}else{%>
			  이미 사용중인
			  <%}%>
              사업자번호 입니다.
			</td>
          </tr>
        </table>
	</td>
  </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td align="right">
	  <%if(ven_size == 0){%>
	  <a href="javascript:Confirm1();" title='등록'><img src=/acar/images/center/button_conf.gif border=0 align=absmiddle></a>&nbsp;
	  <%}else{%>
	  <a href="javascript:Confirm2();" title='중복등록한다'><img src=/acar/images/center/button_reg_jb.gif border=0 align=absmiddle></a>&nbsp;
	  (이미 등록된 사업자번호이지만 상호(업체)가 틀려 신규 등록이 필요한 경우 버튼을 클릭하십시오.)
	  <br>
	  <%}%>
	  <a href="javascript:window.close();" ><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	  </td>
    </tr>
	<%if(ven_size > 0){	%>
    <tr>
      <td><hr></td>
    </tr>	
    <tr>
      <td>&nbsp;</td>
    </tr>		
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='5%' class='title'>연번</td>
            <td width="15%" class='title'>사업자번호</td>
            <td width="40%" class='title'>거래처명</td>			
            <td width="40%" class='title'>주소</td>						
          </tr>
          <%for(int i = 0 ; i < ven_size ; i++){
				TradeBean ven = vens[i];%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%= ven.getS_idno()%></td>
            <td>&nbsp;<%= ven.getCust_name()%>&nbsp;<%if(!ven.getDc_rmk().equals("")){%>(<%= ven.getDc_rmk()%>)<%}%><a href="javascript:setVendor('<%= ven.getCust_code()%>','<%= AddUtil.replace(ven.getCust_name(),"'","")%>','<%= ven.getS_idno()%>');"></a></td>            
            <td>&nbsp;<span title='<%=ven.getS_address()%>'><%=Util.subData(ven.getS_address(), 30)%></span></a></td>			
			</td>            						
          </tr>
          <%}%>		  
        </table>
      </td>
    </tr>	
	<%}%>
  </table>
</form>
</body>
</html>

