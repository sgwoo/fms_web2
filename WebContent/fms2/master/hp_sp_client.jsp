<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.client.* "%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function popup(s_var)
	{
		var fm = document.form1;
		fm.s_var.value = s_var;
		fm.target = '_blank';
		fm.action = 'hp_sp_client_list.jsp';
		fm.submit();
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	Vector vt1 = al_db.getClientStStat(); 
	int vt1_size = vt1.size();
	
	Vector vt2 = al_db.getFirmTypeStat(); 
	int vt2_size = vt2.size();
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_var' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>주요거래처</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>  
    <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>주요거래처</span> - 아마존카와 거래하는 기업리스트</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>  
    <tr>
	<td><table width="100%"  border="0">
      <tr>
        <td>&nbsp;</td>
        <td width="10%">일반대기업</td>
        <td width="28%"><select name="gubun1">
                	  	<option value="1" selected>총자산</option>
                		<option value="2" >총자본</option>
                        <option value="3" >연매출</option>				
                	  </select>&nbsp;&nbsp;
                	  <input type="text" name="gubun2" value="100,000" size="7" class=num>백만원 ~
					  <input type="text" name="gubun3" value="" size="7" class=num>백만원
		</td>		
        <td width="5%"><a href="javascript:popup('일반대기업')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
        <td width="55%">&nbsp;초우량기업</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>중견기업 </td>
        <td><select name="gubun1">
                	  	<option value="1">총자산</option>
                		<option value="2" selected>총자본</option>
                        <option value="3">연매출</option>				
                	  </select>&nbsp;&nbsp;
                	  <input type="text" name="gubun2" value="10,000" size="7" class=num>백만원 ~
					  <input type="text" name="gubun3" value="99,999" size="7" class=num>백만원</td>		
        <td><a href="javascript:popup('중견기업')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
        <td>&nbsp;초우량기업</td>
      </tr>

      <tr>
        <td>&nbsp;</td>
        <td>금융권</td>
        <td><select name="gubun1">
                	  	<option value="1">총자산</option>
                		<option value="2" selected>총자본</option>
                        <option value="3">연매출</option>				
                	  </select>&nbsp;&nbsp;
                	  <input type="text" name="gubun2" value="" size="7" class=num>백만원 ~
					  <input type="text" name="gubun3" value="" size="7" class=num>백만원</td>		
        <td><a href="javascript:popup('금융권')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
        <td>&nbsp;초우량기업 / 업태/종목=금융 </td>
      </tr>

      <tr>
        <td>&nbsp;</td>
        <td>외국계기업</td>
        <td><select name="gubun1">
                	  	<option value="1">총자산</option>
                		<option value="2" selected>총자본</option>
                        <option value="3">연매출</option>				
                	  </select>&nbsp;&nbsp;
                	  <input type="text" name="gubun2" value="" size="7" class=num>백만원 ~
					  <input type="text" name="gubun3" value="" size="7" class=num>백만원</td>		
        <td><a href="javascript:popup('외국계기업')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
        <td>&nbsp;초우량기업 / 상호 : 코리아,한국 / 대표자 : 8자이상 </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>벤처,IT기업</td>
        <td><select name="gubun1">
                	  	<option value="1">총자산</option>
                		<option value="2" selected>총자본</option>
                        <option value="3">연매출</option>				
                	  </select>&nbsp;&nbsp;
                	  <input type="text" name="gubun2" value="" size="7" class=num>백만원 ~
					  <input type="text" name="gubun3" value="" size="7" class=num>백만원</td>		
        <td><a href="javascript:popup('벤처,IT기업')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
        <td>&nbsp;초우량기업 / 업태/종목 : IT, 인터넷, 반도체, 전자, 소프트웨어, 개발</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>영리법인</td>
        <td>재단/법무/회계/세무/노무/관세....법인</td>		
        <td><a href="javascript:popup('재단/법무/회계/세무/노무/관세법인')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
        <td>&nbsp;상호 : 법인 / 비영리법인 제외</td>
      </tr>	  	  	  	  
      <tr>
        <td>&nbsp;</td>
        <td>비영리법인</td>
        <td>&nbsp;</td>		
        <td><a href="javascript:popup('비영리법인')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
        <td>&nbsp;사업자등록번호 가운데 번호 82</td>
      </tr>	  
      <tr>
        <td>&nbsp;</td>
        <td>정부기관</td>
        <td>국가/지방자치단체/지방자치단체조합..</td>		
        <td><a href="javascript:popup('정부기관')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
        <td>&nbsp;사업자등록번호 가운데 번호 83 / 법인형태 : 국가,지방자치단체,정부투자기관,정부출연연구기관</td>
      </tr>
    </table></td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객구분별 고객수현황 </span> - 아마존카와 거래하는 고객
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>  
  <tr>
  	<td>
	  <table width="100%"  border="0">
  		<%int tot_client_cnt = 0;
		  for(int i = 0 ; i < vt1_size ; i++){
    		Hashtable ht = (Hashtable)vt1.elementAt(i);
			tot_client_cnt += AddUtil.parseInt(String.valueOf(ht.get("CNT"))); %>
        <tr>
          <td>&nbsp;</td>
          <td width="18%"><%=ht.get("CLIENT_ST_NM")%></td>
          <td width="20%" align="right"><%=ht.get("CNT")%>건</td>		
          <td width="5%"></td>
          <td width="55%"></td>
        </tr>
  		<%}%>	
        <tr>
          <td>&nbsp;</td>		
          <td colspan="2"><hr></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>				
        <tr>
          <td>&nbsp;</td>
          <td align="center">합계</td>
          <td align="right"><%=tot_client_cnt%>건</td>		
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>			
      </table>
	</td>
  </tr>	  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>법인고객의 법인형태별 고객수현황 </span> - 아마존카와 거래하는 고객
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>  
  <tr>
  	<td>
	  <table width="100%"  border="0">
  		<%tot_client_cnt = 0;
		  for(int i = 0 ; i < vt2_size ; i++){
    		Hashtable ht = (Hashtable)vt2.elementAt(i);
			tot_client_cnt += AddUtil.parseInt(String.valueOf(ht.get("CNT"))); %>
        <tr>
          <td>&nbsp;</td>
          <td width="18%"><%=ht.get("FIRM_TYPE_NM")%></td>
          <td width="20%" align="right"><%=ht.get("CNT")%>건</td>		
          <td width="5%"></td>
          <td width="55%"></td>
        </tr>
  		<%}%>	
        <tr>
          <td>&nbsp;</td>		
          <td colspan="2"><hr></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>				
        <tr>
          <td>&nbsp;</td>
          <td align="center">합계</td>
          <td align="right"><%=tot_client_cnt%>건</td>		
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>			
      </table>
	</td>
  </tr>	    
  <tr>
  	<td></td>
  </tr>  

  <tr>
	<td>&nbsp;</td>
  </tr>
</table>
</form>
</body>
</html>
