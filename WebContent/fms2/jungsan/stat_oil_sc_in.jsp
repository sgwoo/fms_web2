<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>

<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>

<%

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "3";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page"); //	
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3"); //신차
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4"); //렌트
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5"); //일반식
	
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");//타입
		
	int vt_size2 = 0;
	Vector vts2 = JsDb.getCardJungOilDtStatList(ref_dt1,ref_dt2, gubun3, gubun4 );
	
	vt_size2 = vts2.size();	
	
	long tot_amt = 0;
	long tot_m_amt = 0;	
		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
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
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}
//-->
</script>
</head>
<body rightmargin=0>
<input type='hidden' name='from_page' 	value='<%=from_page%>'>  
<table border=0 cellspacing=0 cellpadding=0 width="1300">
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=4% class=title>연번</td>
                    <td width=7% class=title>거래일자</td>
                    <td width=6% class=title>사용자</td>
                    <td width=6% class=title>소유자</td>
                    <td width=8% class=title>용도구분</td>
                    <td width=9% class=title>차량번호</td>
                    <td width=12% class=title>차명</td>
                    <td width=12% class=title>거래처</td>
                    <td width=10% class=title>사유</td>
                    <td width=6% class=title>주행거리</td>
                    <td width=6% class=title>주유량</td>                
                    <td width=7% class=title>금액</td>                    
                    <td width=7% class=title>경감금액</td>                    
                </tr>
	  
<%
  long  m_amt = 0;
  for(int i = 0 ; i < vt_size2 ; i++){
      	Hashtable ht = (Hashtable)vts2.elementAt(i);
      	
      	tot_amt += AddUtil.parseLong(String.valueOf(ht.get("BUY_AMT")));
      	tot_m_amt += AddUtil.parseLong(String.valueOf(ht.get("M_AMT"))) * (-1);
      		
      	m_amt 	= AddUtil.parseLong(String.valueOf(ht.get("M_AMT"))) * (-1);
%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BUY_DT")))%></td>
                    <td align="center"><%= ht.get("USER_NM") %></td>
                    <td align="center"><%= ht.get("OWNER_NM") %></td>
                    <td align="center"><%= ht.get("ACCT_CODE_G2_NM") %></td>
                    <td align="center"><%= ht.get("CAR_NO") %></td>
                    <td align="center"><span title='<%= ht.get("CAR_NM") %>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
                    <td>&nbsp;<span title='<%=ht.get("FIRM_NM") %>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")) , 10)%></span></td>
                    <td align="center"><%= ht.get("C_NM") %></td>          
                    <td align="right"><%= Util.parseDecimal(ht.get("TOT_DIST")) %></td>          
                    <td align="right"><%= AddUtil.parseFloatCipher(String.valueOf( ht.get("OIL_LITER")), 2) %></td>          
                    <td align="right"><%= Util.parseDecimal(ht.get("BUY_AMT")) %></td>          
                      <td align="right"><%= Util.parseDecimal(m_amt) %></td>              
                </tr>
        <%}%>
        		 <tr> 
		            <td class=title align="center" colspan=11> &nbsp;</td>		    		            
		            <td class=title style="text-align:right"><%=Util.parseDecimal(tot_amt)%></td>      <!--누계 -->    	
		             <td class=title style="text-align:right"><%=Util.parseDecimal(tot_m_amt)%></td>
		  </tr>	  
           
        <% if(vt_size2 == 0){ %>
                <tr> 
                    <td colspan="13" align="center"> &nbsp;등록된 데이타가 없습니다.</td>
                </tr>
        <%}%>
            </table>
        </td>            		            		
	</tr>
</table>
</body>
</html>