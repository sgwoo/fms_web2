<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	String print_st = request.getParameter("print_st")==null?"":request.getParameter("print_st");	
	
	Vector vts = new Vector();
	
	if(AddUtil.parseInt(gubun1) >=2017){
		vts = ScdMngDb.getTaxHapList_2018(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	}else{
		vts = ScdMngDb.getTaxHapList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	}
		
	int vt_size = vts.size();
	
	int  client_cnt[]  	= new int[3];
	int  tax_cnt[]     	= new int[3];
	long tax_supply[] 	= new long[3];
	long tax_value[]  	= new long[3];
%>

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
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr> 
      <td ><select name="gubun1" disabled >
        <% for(int i=2002; i<=AddUtil.getDate2(1); i++){%>
        <option value="<%=i%>" <%if(i == AddUtil.parseInt(gubun1)){%> selected <%}%>><%=i%>년도</option>
        <%}%>
      </select>
        <select name="gubun2" disabled >
          <option value="" <%if(gubun2.equals("")){%> selected <%}%>>전체</option>
          <option value="1" <%if(gubun2.equals("1")){%> selected <%}%>>1분기</option>
          <option value="2" <%if(gubun2.equals("2")){%> selected <%}%>>2분기</option>
          <option value="3" <%if(gubun2.equals("3")){%> selected <%}%>>3분기</option>
          <option value="4" <%if(gubun2.equals("4")){%> selected <%}%>>4분기</option>
        </select>
        <select name="gubun3" onChange='javascript:cng_input()' disabled >
          <option value="" <%if(gubun3.equals("")){%> selected <%}%>>전체</option>
          <% for(int i=1; i<=12; i++){%>
          <option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(gubun3)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
          <%}%>
        </select></td>
    </tr>	
    <tr> 
      <td ></td>
    </tr>	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	    	<tr><td class=line2></td></tr>
          <tr>
            <td width="25%" align='center' class="title">구분</td>
            <td width="25%" align='center' class="title">매출처수</td>
            <td width="10%" align='center' class="title">매수</td>
            <td width="20%" align='center' class="title">공급가액</td>
            <td width="20%" align='center' class="title">세액</td>
          </tr>
          <tr>
            <td align='center' class="title">합계</td>
            <td align='center'><input type="text" name="client_cnt" class="whitenum" size="6"></td>
            <td align='center'><input type="text" name="tax_cnt" class="whitenum" size="6"></td>
            <td align='center'><input type="text" name="tax_supply" class="whitenum" size="14"></td>
            <td align='center'><input type="text" name="tax_value" class="whitenum" size="14"></td>
          </tr>
          <tr>
            <td align='center' class="title">사업자등록번호발행분</td>
            <td align='center'><input type="text" name="client_cnt" class="whitenum" size="6"></td>
            <td align='center'><input type="text" name="tax_cnt" class="whitenum" size="6"></td>
            <td align='center'><input type="text" name="tax_supply" class="whitenum" size="14"></td>
            <td align='center'><input type="text" name="tax_value" class="whitenum" size="14"></td>
          </tr>
          <tr>
            <td align='center' class="title">주민등록번호발행분</td>
            <td align='center'><input type="text" name="client_cnt" class="whitenum" size="6"></td>
            <td align='center'><input type="text" name="tax_cnt" class="whitenum" size="6"></td>
            <td align='center'><input type="text" name="tax_supply" class="whitenum" size="14"></td>
            <td align='center'><input type="text" name="tax_value" class="whitenum" size="14"></td>
          </tr>
        </table>
	  </td>
    </tr>	  	
    <tr> 
      <td ></td>
    </tr>
    <!-- 	
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='100%' id='td_title' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	      	<tr><td class=line2></td></tr>
            <tr> 
            <td width='5%' class='title'>연번</td>
            <td width='20%' class='title'>사업자번호</td>
            <td width='25%' class='title'>상호</td>
            <td width='10%' class='title'>매수</td>
            <td width='20%' class='title'>공급가</td>
            <td width='20%' class='title'>세액</td>
          </tr>
        </table>
      </td>
    </tr> -->
<%	if(vt_size > 0){%>
  <!--  <tr>
	    <td class='line' width='100%' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'> -->
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
      <!--    <tr> 
            <td width='5%' align='center'><%=i+1%></td>
            <td width='20%' align='center'><%=AddUtil.ChangeEnp(AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO"))))%></td>
            <td width='25%' align='center'><span title='<%=ht.get("FIRM_NM")%>(<%=ht.get("CLIENT_ID")%>)'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 20)%></span></td>
            <td width='10%' align='center'><%=ht.get("CNT")%></td>
            <td width='20%' align="right">
			<%  if(print_st.equals("1")){%>
			<%=Util.parseDecimal(String.valueOf(ht.get("TAX_SUPPLY")))%>
			<%	}else{%>
			<%=ht.get("TAX_SUPPLY")%>
			<%	}%>
			</td>
            <td width='20%' align="right">
			<%  if(print_st.equals("1")){%>
			<%=Util.parseDecimal(String.valueOf(ht.get("TAX_VALUE")))%>
			<%	}else{%>
			<%=ht.get("TAX_VALUE")%>
			<%	}%>
			</td>
            </tr> -->
          <%  if(String.valueOf(ht.get("ENP_NO")).length() == 10){
                client_cnt[1] += 1;
                tax_cnt[1]    += AddUtil.parseInt(String.valueOf(ht.get("CNT")));
                tax_supply[1] += AddUtil.parseLong(String.valueOf(ht.get("TAX_SUPPLY")));
                tax_value[1]  += AddUtil.parseLong(String.valueOf(ht.get("TAX_VALUE")));
              }else{
                client_cnt[2] += 1;
                tax_cnt[2]    += AddUtil.parseInt(String.valueOf(ht.get("CNT")));
                tax_supply[2] += AddUtil.parseLong(String.valueOf(ht.get("TAX_SUPPLY")));
                tax_value[2]  += AddUtil.parseLong(String.valueOf(ht.get("TAX_VALUE")));
              }
            }%>			
   <!--      </table>
    </tr> -->
<%	}else{%>                     
    <tr>
	    <td class='line' width='100%' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table>
      </td>
    </tr>
<% 	}%>
  </table>
</form>
<script language='javascript'>
<!--
  var fm = document.form1;
  <% for(int i =1; i<3; i++){%>
  fm.client_cnt[<%=i%>].value = <%=client_cnt[i]%>;
  fm.tax_cnt[<%=i%>].value    = <%=tax_cnt[i]%>;
  fm.tax_supply[<%=i%>].value = parseDecimal(<%=tax_supply[i]%>);
  fm.tax_value[<%=i%>].value  = parseDecimal(<%=tax_value[i]%>);
  <% }%>
  fm.client_cnt[0].value  = toInt(fm.client_cnt[1].value)+toInt(fm.client_cnt[2].value);
  fm.tax_cnt[0].value     = toInt(fm.tax_cnt[1].value)+toInt(fm.tax_cnt[2].value);
  fm.tax_supply[0].value  = parseDecimal(toInt(parseDigit(fm.tax_supply[1].value)) + toInt(parseDigit(fm.tax_supply[2].value)));
  fm.tax_value[0].value   = parseDecimal(toInt(parseDigit(fm.tax_value[1].value)) + toInt(parseDigit(fm.tax_value[2].value)));  
//-->
</script>
</body>
</html>
