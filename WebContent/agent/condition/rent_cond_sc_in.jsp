<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/agent/cookies.jsp" %>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	Vector vt = cdb.getRentCondAll_type2(dt, ref_dt1, ref_dt2, gubun2, gubun3, gubun4, sort, ck_acar_id);
	int vt_size = vt.size();
	
	long t_amt1[] = new long[1];
    	long t_amt2[] = new long[1];
    	long t_amt3[] = new long[1];
    	long t_amt7[] = new long[1];
    
    	float t_amt4[] = new float[1];
    	float t_amt5[] = new float[1];
    	float t_per[] = new float[1];
	
    
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_t.css"></link><script language="JavaScript">
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
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="1320">
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1320">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
            	<tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;' width=12%> 
            		    <table border=0 cellspacing=1 cellpadding=0 width=100%>
                            <tr> 
                                <td width=30% class=title style='height:36'>연번</td>
                                <td width=70% class=title>계약번호</td>
                            </tr>
                        </table>
                    </td>
                    <td class=line width=88%>
            	        <table  border=0 cellspacing=1 cellpadding=0 width=100%>
                            <tr> 
                                <td width=8% class=title style='height:36'>계약일</td>
                                <td width=8% class=title>대여개시일</td>
                                <td width=8% class=title>최초차량<br>등록일</td>
                                <td width=12% class=title>상호</td>
                                <td width=16% class=title>차종</td>
                             	<td width=3% class=title>계약<br>기간</td>
                                <td width=5% class=title>용도<br>구분</td>
                                <td width=5% class=title>관리<br>구분</td>
                             	<td width=8% class=title>대여료산정<br>기준가격</td>
                             	<td width=7% class=title>선수금</td>
                             	<td width=5% class=title>선수율</td>
                             	<td width=7% class=title>대여료</td>
                             	<td width=8% class=title>총대여료</td>                         	         					
                            </tr>
                        </table>
			        </td>
				</tr>
<%	if(vt_size > 0){ %>

            	<tr>            		
                    <td class=line id='D1_col' style='position:relative;' width=12%> 
                        <table border=0 cellspacing=1 cellpadding=0 width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                            <tr> 
                                <td align="center" width=30%><%= i+1%></td>
                                <td align="center" width=70%><%=ht.get("RENT_L_CD")%></a></td>
                            </tr>
              <%}%>
                            <tr> 
                                <td class=title colspan="5" align="center">합계</td>
                            </tr>	
                        </table>
                    </td>            		           
                    <td class=line width=88%>
            			<table border=0 cellspacing=1 cellpadding=0 width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i); 
					
								 	
			 		t_amt2[0] += AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S"))) + AddUtil.parseLong(String.valueOf(ht.get("PP_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("IFEE_AMT")));
			 		t_amt7[0] += AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")));
			 		t_amt3[0] += AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")))* AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
					
					t_amt4[0] =  AddUtil.parseFloat(String.valueOf(ht.get("GRT_AMT_S"))) + AddUtil.parseFloat(String.valueOf(ht.get("PP_AMT"))) + AddUtil.parseFloat(String.valueOf(ht.get("IFEE_AMT"))); 
					
					
					if ( ht.get("EXT_ST").equals("연장")) {
						t_amt5[0] =  AddUtil.parseFloat(String.valueOf(ht.get("SH_AMT"))); 
						t_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("SH_AMT")));
					} else { 
					    if ( ht.get("CAR_GU").equals("재리스")) {
							t_amt5[0] =  AddUtil.parseFloat(String.valueOf(ht.get("SH_AMT"))); 
							t_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("SH_AMT")));
						} else {
							t_amt5[0] =  AddUtil.parseFloat(String.valueOf(ht.get("CAR_AMT"))); 
							t_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("CAR_AMT")));
						}
					}
					
					t_per[0] =  t_amt4[0]/t_amt5[0]* 100;
					
			%>
                            <tr> 
                                <td width=8% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                                <td width=8% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                                <td width=8% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                                <td width=12% align="left">&nbsp;<span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></a></span></td>                            
                                <td width=16% align="left">&nbsp;<span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>"><%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),15) %></span></td>                            
                                <td width=3% align="center"><%=ht.get("CON_MON")%></td>
                                <td width=5% align="center"><%=ht.get("CAR_ST")%></td>								
                                <td width=5% align="center"><%=ht.get("RENT_WAY")%></td>		                                
                                <td width=8% align="right"><%=Util.parseDecimal(t_amt5[0])%></td>	
                                <td width=7% align="right"><%=Util.parseDecimal(t_amt4[0])%></td>	
                                <td width=5% align="right"><%=AddUtil.parseFloatCipher2(t_per[0],1)%></td>	
                                <td width=7% align="right"><%=Util.parseDecimal(ht.get("FEE_AMT"))%></td>	
                                <td width=8% align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")))* AddUtil.parseLong(String.valueOf(ht.get("CON_MON"))))%></td>	
               				
                            </tr>
              <%}%>
 <%  
 			float g_per = 0;
 			float g_amt2 = 0;
 			float g_amt1 = 0;
 			
 			g_amt2 = (float) t_amt2[0];
 			g_amt1 = (float) t_amt1[0];
 			g_per = g_amt2/g_amt1 * 100;
 			
 %>             
                            <tr> 
                	            <td class=title style="text-align:right" colspan=8>&nbsp;</td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%></td>
                	            <td class=title style="text-align:right"><%=AddUtil.parseFloatCipher2(g_per,1)%></td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt7[0])%></td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>
	                        </tr>	  
                        </table>
			        </td>            		            		
            	</tr>
<%}%>
<%	if(vt_size == 0){%>
	            <tr>            		
                    <td class=line id='D1_col' style='position:relative;' width=12%> 
            		    <table border=0 cellspacing=1 cellpadding=0 width=100%>
                            <tr> 
                                <td align="center" width=150></td>
                            </tr>
                        </table>
                    </td>            		            		
            		<td class=line width=88%>
            			<table border=0 cellspacing=1 cellpadding=0 width=100%>
							<tr>
								<td>&nbsp;등록된 데이타가 없습니다.</td>
			            	</tr>
			            </table>
			        </td>            		            		
            	</tr>
<%}%>
            </table>
        </td>
    </tr>
</table>

</body>
</html>