<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	Vector vts2 = CardDb.getCardUseComMStatCD(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size2 = vts2.size();
	

%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
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
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//카드내용보기
	function CardUseList(buy_dt){
		var fm = document.form1;
		fm.st_dt.value = buy_dt;
		fm.chk1.value = "3";
		fm.action = "card_use_com_d_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width='<%=300+(150*vt_size2)%>'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='300' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td width='15%' rowspan="2" class='title'>연번</td>
                <td width='30%' rowspan="2" class='title'>일자</td>
                <td colspan="2" class='title'>소계</td>
              </tr>
              <tr>
                <td width='20%' class='title'>건수</td>
                <td width='35%' class='title'>금액</td>
              </tr>
            </table></td>
	    <td class='line' width='<%=150*vt_size2%>'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='<%=150*vt_size2%>'>
              <tr> 
                <%for(int i = 0 ; i < vt_size2 ; i++){
    				Hashtable ht = (Hashtable)vts2.elementAt(i);%>		  
                <td colspan="2" class='title'><span title='<%=ht.get("COM_NAME")%>'><%=Util.subData(String.valueOf(ht.get("COM_NAME")), 10)%></span></td>
    			<%}%>
              </tr>
              <tr>
                <%
    
    			for(int i = 0 ; i < vt_size2 ; i++){
    				Hashtable ht = (Hashtable)vts2.elementAt(i);
    %>		  
                <td width='50' class='title'>건수</td>
                <td width='100' class='title'>금액</td>
    			<%}%>
              </tr>
            </table>
	    </td>
    </tr>
<%	int  t_cnt[] = new int[vt_size2+1];
  	long t_amt[] = new long[vt_size2+1];
	Vector vts = CardDb.getCardUseComMStat(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
	if(vt_size > 0){%>
    <tr>
	    <td class='line' width='300' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vts.elementAt(i);
    				t_cnt[0] += AddUtil.parseInt(String.valueOf(ht.get("CNT0")));
    				t_amt[0] += AddUtil.parseLong(String.valueOf(ht.get("AMT0")));%>
              <tr> 
                <td width='15%' align="center"><%=i+1%></td>
                <td width='30%' align="center"><a href="javascript:CardUseList('<%=ht.get("BUY_DT")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BUY_DT")))%></a></td>
                <td width='20%' align="right"><%=ht.get("CNT0")%>건</td>
                <td width='35%' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT0")))%>원</td>
              </tr>
              <%}%>
              <tr> 
                <td class=title colspan="2" align="center">합계</td>
                <td class=title style="text-align:right"><%=t_cnt[0]%>건</td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt[0])%>원</td>
              </tr>		  
            </table></td>
	    <td class='line' width='<%=150*vt_size2%>'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='<%=150*vt_size2%>'>
              <%for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vts.elementAt(i);
    				for(int j=1; j<vt_size2+1; j++){
    					t_cnt[j] += AddUtil.parseInt(String.valueOf(ht.get("CNT"+j)));
    					t_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT"+j)));
    				}%>
              <tr> 
    		    <%for(int j=1; j<vt_size2+1; j++){%>
                <td width='50' align="right"><%=ht.get("CNT"+j)%>건</td>
                <td width='100' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT"+j)))%>원</td>
    		    <%}%>
              </tr>
              <%}%>
              <tr> 
    		    <%for(int j=1; j<vt_size2+1; j++){%>
                <td class=title style="text-align:right"><%=t_cnt[j]%>건</td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt[j])%>원</td>
    		    <%}%>
              </tr>		  
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='300' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td align='center'>등록된 데이타가 없습니다</td>
              </tr>
            </table></td>
	    <td class='line' width='<%=150*vt_size2%>'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='<%=150*vt_size2%>'>
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
