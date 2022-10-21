<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"8":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rent="";
	int count= 0;
	int  cnt[]   = new int[8];
  	long amt[]   = new long[8];
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector settles = s_db.getSettlePreList3(gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd);
	int settle_size = settles.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=settle_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='1520'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='430' id='td_title' style='position:relative;'>			
        <table border="0" cellspacing="1" cellpadding="0" width='430'>
          <tr> 
            <td colspan="4" class='title'>기본 정보</td>
          </tr>
          <tr> 
            <td width='60' class='title'>연번</td>
            <td class='title' width="110">계약번호</td>
            <td width='160' class='title'>상호</td>
            <td class='title' width="100">차량번호</td>
          </tr>
        </table>
	</td>
	<td class='line' width='1090'>			
        <table border="0" cellspacing="1" cellpadding="0" width='1090'>
          <tr> 
            <td class='title' colspan="2">선수금</td>
            <td class='title' colspan="2">대여료</td>
            <td class='title' colspan="2">과태료</td>
            <td class='title' colspan="2">면책금</td>
            <td class='title' colspan="2">휴/대차료</td>
            <td class='title' colspan="2">중도해지위약금</td>
            <td class='title' colspan="2">단기요금</td>			
            <td class='title' colspan="2">합계</td>			
            <td class='title' width="80" rowspan="2">영업담당자</td>
            <td class='title' width="50" rowspan="2">정산서</td>
          </tr>
          <tr> 
            <td width='40' class='title'>건수</td>
            <td width='80' class='title'>금액</td>
            <td width='40' class='title'>건수</td>
            <td width='80' class='title'>금액</td>
            <td width='40' class='title'>건수</td>
            <td width='80' class='title'>금액</td>
            <td width='40' class='title'>건수</td>
            <td width='80' class='title'>금액</td>
            <td width='40' class='title'>건수</td>
            <td width='80' class='title'>금액</td>
            <td width='40' class='title'>건수</td>
            <td width='80' class='title'>금액</td>
            <td width='40' class='title'>건수</td>
            <td width='80' class='title'>금액</td>			
            <td width='40' class='title'>건수</td>
            <td width='80' class='title'>금액</td>			
          </tr>
        </table>
	</td>
  </tr>
<%	if(settle_size > 0){%>
  <tr>
	<td class='line' width='430' id='td_con' style='position:relative;'>			
        <table border="0" cellspacing="1" cellpadding="0" width='430'>
          <%		for (int i = 0 ; i < settle_size ; i++){
			Hashtable settle = (Hashtable)settles.elementAt(i);%>
          <tr> 
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='60' align='center'><a href="javascript:parent.view_memo('','<%=settle.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"  title="<%=af_db.getMaxMemo("", String.valueOf(settle.get("RENT_L_CD")), "")%>"><%=i+1%> 
              <%if(settle.get("USE_YN").equals("N")){%>
              (해약) 
              <%}%></a>
            </td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="110"><a href="javascript:parent.view_settle('cont','','<%=settle.get("RENT_L_CD")%>','<%=settle.get("CLIENT_ID")%>','<%=settle.get("CAR_MNG_ID")%>','<%=settle.get("GUBUN3")%>')" onMouseOver="window.status=''; return true"><%=settle.get("RENT_L_CD")%></a></td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='160' align='center'><span title='<%=settle.get("GUBUN3")%> <%=settle.get("FIRM_NM")%>'><a href="javascript:parent.view_settle('client','','<%=settle.get("RENT_L_CD")%>','<%=settle.get("CLIENT_ID")%>','<%=settle.get("CAR_MNG_ID")%>','<%=settle.get("GUBUN3")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(settle.get("GUBUN3"))+" "+String.valueOf(settle.get("FIRM_NM")), 12)%></a></span></td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="100"><%=settle.get("CAR_NO")%></td>
          </tr>
          <%		}%>
        </table>
	</td>
	<td class='line' width='1090'>			
        <table border="0" cellspacing="1" cellpadding="0" width='1090'>
          <%		for (int i = 0 ; i < settle_size ; i++){
						Hashtable settle = (Hashtable)settles.elementAt(i);
						for(int j=0; j<8; j++){
							cnt[j]  += AddUtil.parseInt(String.valueOf(settle.get("EST_SU"+j)));
							amt[j]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT"+j)));
						}%>
          <tr> 
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU1")%>건&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT1")))%>원&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU2")%>건&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT2")))%>원&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU3")%>건&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT3")))%>원&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU4")%>건&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT4")))%>원&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU5")%>건&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT5")))%>원&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU6")%>건&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT6")))%>원&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU7")%>건&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT7")))%>원&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='right'><%=settle.get("EST_SU0")%>건&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT0")))%>원&nbsp;</td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="80">&nbsp;<%=c_db.getNameById(String.valueOf(settle.get("BUS_ID2")),"USER")%></td>
            <td <%if(settle.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width="50"><a href="javascript:parent.view_settle_doc('<%//=settle.get("RENT_MNG_ID")%>','<%=settle.get("RENT_L_CD")%>')">보기</a></td>
          </tr>
          <%		}%>
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	<td class='line' width='430' id='td_con' style='position:relative;'>			
      <table border="0" cellspacing="1" cellpadding="0" width='430'>
        <tr>
		  <td align='center'>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
	<td class='line' width='1040'>			
        <table border="0" cellspacing="1" cellpadding="0" width='1040'>
          <tr>
		  <td>&nbsp;</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
	<%for(int j=0; j<8; j++){%>
	parent.document.form1.cnt[<%=j%>].value = '<%=cnt[j]%>';
	parent.document.form1.amt[<%=j%>].value = '<%=Util.parseDecimal(amt[j])%>';
	<%}%>
//-->
</script>
</form>
</body>
</html>
