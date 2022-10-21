<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.parts.*"%>
<jsp:useBean id="p_db" scope="page" class="acar.parts.PartsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String reqseq = request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String ch_dt = request.getParameter("ch_dt")==null?"":request.getParameter("ch_dt");
	
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String tax_no = request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	int count = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//공급자
	Hashtable br            = c_db.getBranch("S1");
	
	Vector  item = p_db.getDocCase(reqseq, car_mng_id, ch_dt);
	int item_size1 = item.size();
	
	long item_qty = 0;
	long item_s_amt1 = 0;
	long item_v_amt1 = 0;
	long item_s_amt2 = 0;
		

%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/print.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function pagesetPrint(){
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			IE_Print();
		}
	}

	function IE_Print(){
		factory1.printing.header='';
		factory1.printing.footer='';
		factory1.printing.leftMargin=20;
		factory1.printing.rightMargin=20;
		factory1.printing.topMargin=20;
		factory1.printing.bottomMargin=20;
		factory1.printing.Print(true, window);
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name='form1' method='post'  target=''>
  <table border='0' cellspacing='0' cellpadding='0' width='600'>
    <tr> 
      <td colspan="2"> 
        <table width='600' cellpadding="0" cellspacing="0">
          <tr> 
            <td colspan="2"> 
              <table width="600" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td style="border: #000000 2px solid" align="center" valign="middle"> 
                    <table width="95%" border="0" cellspacing="0" cellpadding="0" height="95%">
                      <tr> 
                        <td height="20">&nbsp;</td>
                        <td height="20">&nbsp;</td>
                        <td height="20">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="210">&nbsp;</td>
                        <td align="center" width="180" style="border-bottom: #000000 1px solid" height="30"><font size="5">거 
                          래 명 세 서</font></td>
                        <td width="210">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td align="center" height="25" valign="bottom"><!--(고 객 용)--></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="50%" height="40">&nbsp;</td>
                      <td width="5%">&nbsp;</td>
                      <td rowspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td height="150" rowspan="5" width="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공<br>
                                <br>
                        급<br>
                        <br>
                        자</td>
                            <td height="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">등록번호</td>
                            <td height="30" colspan="3" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%= AddUtil.ChangeEnp(String.valueOf(br.get("BR_ENT_NO")))%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">상호</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont">주식회사아마존카 </span></td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">성명</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_OWN_NM")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">사업장<br>주소</td>
                            <td height="30" colspan="3" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_ADDR")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">업태</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("BR_STA")%></span></td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">종목</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_ITEM")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">대표전화</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("TEL")%></span>&nbsp;</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">팩스</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("FAX")%></span>&nbsp;</td>
                          </tr>
                      </table></td>
                    </tr>
         <%if(item_size1 > 0){
                    for(int i = 0 ; i <1 ; i++){
				Hashtable ht = (Hashtable)item.elementAt(i);						
		%>
				
                      <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="22" width="25%">차&nbsp;량&nbsp;번&nbsp;호</td>
                                    <td height="22" width="5%" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=ht.get("CAR_NO")%></td>
                                    <td height="22" width="20%">&nbsp;</td>
                                  </tr>
                                       <tr> 
                                    <td height="22" width="25%">차&nbsp;&nbsp;&nbsp;&nbsp;명&nbsp;</td>
                                    <td height="22" width="5%" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=ht.get("CAR_NM")%></td>
                                    <td height="22" width="20%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="22">출&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;일</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=AddUtil.getDate3(String.valueOf(ht.get("CH_DT")))%></td>
                                    <td height="22">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="22">상&nbsp;&nbsp;&nbsp;&nbsp;호&nbsp;</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="3">&nbsp;<%=ht.get("FIRM_NM")%>	</td>
                                  </tr>
                                   <tr> 
                                    <td height="22">정&nbsp;비&nbsp;업&nbsp;체</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="3">&nbsp;<%=ht.get("OFF_NM")%>	</td>
                                  </tr>
                                  <tr> 
                                    <td height="22" colspan="5"><b></b></td>
                                  </tr>
                                 </table>
                              </td>
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                  <%		}  
    	 } %>     
    	 
    
                      <tr> 
                        <td height="20" align="right"></td>
                        <td height="30" rowspan="2">&nbsp;</td>
                        <td height="30" align="right" rowspan="2"></td>
                      </tr>
                      <tr> 
                        <td height="15" align="right">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="center" bgcolor="#CCCCCC"> 
                              <td rowspan="2" width="25" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
                              <td rowspan="2" width="130" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">부품명</td>
                              <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">부품코드</td>
                              <td rowspan="2" width="40" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">수량</td>
                              <td height="20" colspan="3" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">부품가격</td>
                              <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">비고</td>
                            </tr>
                            <tr> 
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">합계</td>
                            </tr>
                            
               <%if(item_size1 > 0){
                    for(int i = 0 ; i <item_size1 ; i++){
				Hashtable ht = (Hashtable)item.elementAt(i);						
		%>                           
                            
                              <%			item_s_amt1 = item_s_amt1 +  Long.parseLong(String.valueOf(ht.get("R_S_AMT")));
						item_v_amt1 = item_v_amt1+  Long.parseLong(String.valueOf(ht.get("R_V_AMT")));
						item_qty = item_qty  + Long.parseLong(String.valueOf(ht.get("QTY")));
			%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=i+1%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=ht.get("PARTS_NM")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;<%=ht.get("PARTS_NO")%></font></td>
                               <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=Util.parseDecimal(String.valueOf(ht.get("QTY")))%>&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=Util.parseDecimal(String.valueOf(ht.get("R_S_AMT")))%>&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=Util.parseDecimal(String.valueOf(ht.get("R_V_AMT")))%>&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" ><font size="1"><%=Util.parseDecimal(Long.parseLong(String.valueOf(ht.get("R_S_AMT")))+Long.parseLong(String.valueOf(ht.get("R_V_AMT"))))%>&nbsp;</font></td>
                               <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"">&nbsp;</td>
                           </tr>
                              <%		}  
    	 } %>              
    	 
                            <%		for(int i = 0 ; i < 20-item_size1 ; i++){%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                               <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>   
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                            </tr>
                            <%	}%>
                            <tr> 
                              <td height="22" colspan="3" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계</b></font></td>
                               <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_qty)%>&nbsp;</font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_s_amt1)%>&nbsp;</font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_v_amt1)%>&nbsp;</font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_s_amt1+item_v_amt1)%>&nbsp;</font></td>
                                <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid" align="right"><font size="1">&nbsp;</font></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="3"><font size="1"></font></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
    </tr>
  </table>
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 575px; WIDTH: 68px; POSITION: absolute; TOP: 120px; HEIGHT: 68px"><IMG src="../../images/3c7kR522I6Sqs_70.gif"></DIV>
  </form>
<script language='javascript'>
<!--	
//-->
</script>
</body>
</html>