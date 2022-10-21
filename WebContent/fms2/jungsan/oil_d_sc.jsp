<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="j_db" scope="page" class="card.JungSanDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
   
   
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String sort		= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String make		= request.getParameter("make")==null?"":request.getParameter("make");
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");		
	String dept_nm = "";

	int vt_size2 = 0;
	
	//procedure 호출
	//if ( !dt.equals("9")) {
   // 	j_db.call_sp_oil_jungsanNew(dt, ref_dt1, ref_dt2, ck_acar_id);
	//}
	
	Vector vts2 = new Vector();
	
	vts2 = j_db.getCardJungOilDtStatNew(dt, ref_dt1, ref_dt2, sort, ck_acar_id);
	
	
	vt_size2 = vts2.size();	
	
	int   p_cnt[] = new int[3];
	
	long t_amt[] = new long[1];	
	float u_amt[] = new float[1];
	long o_amt[] = new long[1];	
	
	long t1_amt[] = new long[1];	
	float u1_amt[] = new float[1];
	long o1_amt[] = new long[1];	
		
	long t2_amt[] = new long[1];	
	float u2_amt[] = new float[1];
	long o2_amt[] = new long[1];	
	
	long t3_amt[] = new long[1];	
	float u3_amt[] = new float[1];
	long o3_amt[] = new long[1];	
	
	int c_ave = 0;
	int c1_ave = 0;
	int c2_ave = 0;
	int c3_ave = 0;
     
	float f_c_ave = 0;
	float f_c1_ave = 0;
	float f_c2_ave = 0;
	float f_c3_ave = 0;
		
    float cc_ave = 0;
    float cc1_ave = 0;
    float cc2_ave = 0;
    float cc3_ave = 0;
	
    for(int i = 0 ; i < vt_size2 ; i++){
		Hashtable ht = (Hashtable)vts2.elementAt(i);					
		
		for(int j=0; j<1; j++){
			
		    t_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("A_OIL")));				
			u_amt[j] += AddUtil.parseFloat(String.valueOf(ht.get("U_MON")));
			o_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));				
						
			t1_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("O1_AMT")));
			u1_amt[j] += AddUtil.parseFloat(String.valueOf(ht.get("U1_MON")));
			o1_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("OIL1_AMT")));		
			t2_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("O2_AMT")));	
			u2_amt[j] += AddUtil.parseFloat(String.valueOf(ht.get("U2_MON")));
			o2_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("OIL2_AMT")));	
			t3_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("O3_AMT")));
			u3_amt[j] += AddUtil.parseFloat(String.valueOf(ht.get("U3_MON")));
			o3_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("OIL3_AMT")));	
						
			if (  AddUtil.parseLong(String.valueOf(ht.get("O1_AMT"))) > 0 ){  //lpg
				p_cnt[0] += 1;
			}
			if (  AddUtil.parseLong(String.valueOf(ht.get("O2_AMT"))) > 0 ){  //경유 
				p_cnt[1]  += 1;
			} 
			if (  AddUtil.parseLong(String.valueOf(ht.get("O3_AMT"))) > 0 ){  //전기 
				p_cnt[2]  += 1;
			}
		}
    }
	 
  /*  out.println(o2_amt[0]);
    out.println(u2_amt[0]);
    out.println(o3_amt[0]);
    out.println(u3_amt[0]); */
    
    if ( vt_size2 > 0)  { 
    	 f_c_ave =  o_amt[0]/u_amt[0] ;  
	     c_ave = (int) f_c_ave;
	     f_c1_ave =  o1_amt[0]/u1_amt[0];  
	     c1_ave = (int) f_c1_ave;
	     f_c2_ave =  o2_amt[0]/u2_amt[0]; 
	     c2_ave = (int) f_c2_ave;
	     f_c3_ave =  o3_amt[0]/u3_amt[0];
	     c3_ave = (int) f_c3_ave;
	      
	     cc_ave =  u_amt[0]/vt_size2;          
	     cc1_ave = u1_amt[0]/p_cnt[0];              
	     cc2_ave = u2_amt[0]/p_cnt[1];                
	     cc3_ave = u3_amt[0]/p_cnt[2]; 
    }   
     
%>	 	


<html>
<head>
<title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<form name='form1'  id="form1" action='' method='post' >
<input type='hidden' name='height' id="height" value='<%=height%>'>
<font size=2>* 조회기간 검색시 해당기간 데이타 생성 후 검색하세요. </font><br>
<table border="0" cellspacing="0" cellpadding="0" width="1600">
<tr id='tr_title' style='position:relative;z-index=1'>
 <td class='' width='120' id='td_title' >  
		<div class="tb_wrap">
			<div class="tb_title_box custom_scroll">
				<table class="tb">
					<tr>				
						<td style="width:100%;">
							<div style="width:100%;">
								<table class="inner_top_table table_layout" style="height: 60px;">
								     <colgroup>
								     	<col width="4%">		       			
						       			<col width="8%">		       			
						       			<col width="6%">	
						       			<col width="6%">		       			
						       			<col width="7%">		       			
						       			<col width="6%">	
						       			<col width="6%">		
						       			<col width="6%">			
					                 <%for (int j = 1; j <=3 ; j++){%>
						       			<col width="7%">
						       			<col width="5%">
						       			<col width="5%">
						       		 <%}%>
						       				       			
						       		</colgroup>
					               	<tr> 
										<td rowspan=3 class='title title_border' style='height:75' width='4%'>연번</td>
										<td rowspan=3 class='title title_border' width='8%'>부서</td>
										<td rowspan=3 class='title title_border' width='6%'>직급</td>
										<td rowspan=3  class='title title_border' width='6%'>성명</td>		
							            <td colspan="4"  class='title title_border' width='25%'>조회기간</td>
							            <td colspan="9"  class='title title_border' width='51%'>연료별 월평균 사용금액 </td> 
							         </tr>
							         <tr>
							            <td width='7%' rowspan=2 class='title title_border'>월평균(금액)</td>
							            <td width='6%' rowspan=2 class='title title_border'>평균대비</td>
							            <td width='6%' rowspan=2 class='title title_border'>이용개월</td>
							            <td width='6%' rowspan=2 class='title title_border'>연료(현재)</td> 
							            <td width='17%' colspan=3 class='title title_border'>LPG</td> 
							            <td width='17%' colspan=3 class='title title_border'>경유·휘발유	</td> 
							            <td width='17%' colspan=3 class='title title_border'>전기·수소</td>              
							         </tr>
							          <tr>
							            <td width='7%' class='title title_border'>월평균</td>
							            <td width='5%' class='title title_border'>평균대비</td>
							            <td width='5%' class='title title_border'>이용개월</td>
							            <td width='7%' class='title title_border'>월평균</td>
							            <td width='5%' class='title title_border'>평균대비</td>
							            <td width='5%' class='title title_border'>이용개월</td>
							            <td width='7%' class='title title_border'>월평균</td>
							            <td width='5%' class='title title_border'>평균대비</td>
							            <td width='5%' class='title title_border'>이용개월</td>		         
							         </tr>
				                      <tr> 
							            <td class='title title_border' colspan="4" align="center">평균(가중평균)</td>                
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c_ave)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=AddUtil.parseFloatCipher(cc_ave, 1)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c1_ave)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=AddUtil.parseFloatCipher(cc1_ave, 1)%></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c2_ave)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=AddUtil.parseFloatCipher(cc2_ave, 1)%></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c3_ave)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=AddUtil.parseFloatCipher(cc3_ave, 1)%></td>
							          </tr>	  
					     		</table>
					        </div>
					    </td>  
					</tr>    		     
		    	</table>
			</div>
			
			<div class="tb_box">
				<table class="tb">
					<tr>
					   <td style="width:100%;">	
				     	 <div style="width:100%;">	
							<table class="inner_top_table table_layout"> 
		<% if ( vt_size2 > 0) { %>					
		 <%	
		 
		 
				      		long amt[] = new long[1];
				            long amt1[] = new long[1];
				            long amt2[] = new long[1];
				            long amt3[] = new long[1];
					        			        	
						    for(int i = 0 ; i < vt_size2 ; i++){
									Hashtable ht = (Hashtable)vts2.elementAt(i);					
									//명칭
									dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));
								
									
									for(int j=0; j<1; j++){
										amt[j] = AddUtil.parseLong(String.valueOf(ht.get("A_OIL")));	// 평균	
										amt1[j] = AddUtil.parseLong(String.valueOf(ht.get("O1_AMT")));					
										amt2[j] = AddUtil.parseLong(String.valueOf(ht.get("O2_AMT")));					
										amt3[j] = AddUtil.parseLong(String.valueOf(ht.get("O3_AMT")));					
									}
									
									float  c_amt = 0;
									float  c_amt1 = 0;
									float  c_amt2 = 0;
									float  c_amt3 = 0;
									
									c_amt = (float) amt[0]/c_ave*100;
									c_amt1 = (float) amt1[0]/c1_ave*100;
									c_amt2 = (float) amt2[0]/c2_ave*100;
									c_amt3 = (float) amt3[0]/c3_ave*100;
											
							%>
				                  <tr> 
							          	<td class='center content_border'  width='4%'><%= i+1%></td>
							            <td width='8%' class='center content_border' ><%=dept_nm%></td>
							            <td width='6%' class='center content_border'><%=ht.get("USER_POS")%></td>
							            <td width='6%' class='center content_border'><%=ht.get("USER_NM")%></td>
							  			<td width='7%' class='right content_border'><%=Util.parseDecimal(amt[0])%></td>
							            <td width='6%' class='right content_border'><%=AddUtil.parseFloatCipher(c_amt, 1)%></td>
							            <td width='6%' class='right content_border'><%=AddUtil.parseFloatCipher( String.valueOf(ht.get("U_MON")), 1)%></td>
							            <td width='6%' class='center content_border'><%=String.valueOf(ht.get("FUEL_NM"))%></td>
							            
							            <td width='7%' class='right content_border' ><%=Util.parseDecimal(amt1[0])%></td>
							            <td width='5%' class='right content_border' ><%=AddUtil.parseFloatCipher(c_amt1, 1)%></td>
							            <td width='5%' class='right content_border' ><%=AddUtil.parseFloatCipher( String.valueOf(ht.get("U1_MON")), 1)%></td>
							            
							            <td width='7%' class='right content_border' ><%=Util.parseDecimal(amt2[0])%></td>
							            <td width='5%' class='right content_border' ><%=AddUtil.parseFloatCipher(c_amt2, 1)%></td>
							            <td width='5%' class='right content_border' ><%=AddUtil.parseFloatCipher( String.valueOf(ht.get("U2_MON")), 1)%></td>
							            
							            <td width='7%' class='right content_border' ><%=Util.parseDecimal(amt3[0])%></td>
							            <td width='5%' class='right content_border' ><%=AddUtil.parseFloatCipher(c_amt3, 1)%></td>
							            <td width='5%' class='right content_border' ><%=AddUtil.parseFloatCipher( String.valueOf(ht.get("U3_MON")), 1)%></td>                      
							          </tr>          
				          <%		}%>
					                 <tr> 
							            <td class='title title_border' colspan="2" rowspan=4 align="center">전체</td>   
							            <td class='title title_border' colspan="2" align="center">단순합계</td>                
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(t_amt[0])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(u_amt[0])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(t1_amt[0])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(u1_amt[0])%></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(t2_amt[0])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(u2_amt[0])%></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(t3_amt[0])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(u3_amt[0])%></td>
							          </tr>	  
							          <tr> 
							            <td class='title title_border' colspan="2" align="center">인원수</td>                
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(vt_size2)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(vt_size2)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(p_cnt[0])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(p_cnt[0])%></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(p_cnt[1])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(p_cnt[1])%></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(p_cnt[2])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(p_cnt[2])%></td>
							          </tr>	  
							           <tr> 
							            <td class='title title_border' colspan="2" align="center">평균(가중평균)</td>                
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c_ave)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=AddUtil.parseFloatCipher(cc_ave, 1)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c1_ave)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=AddUtil.parseFloatCipher(cc1_ave, 1)%></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c2_ave)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=AddUtil.parseFloatCipher(cc2_ave, 1)%></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c3_ave)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=AddUtil.parseFloatCipher(cc3_ave, 1)%></td>
							          </tr>	  
							           <tr> 
							            <td class='title title_border' colspan="2" align="center">가중평균×인원수</td>                
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c_ave*vt_size2)%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c1_ave*p_cnt[0])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c2_ave*p_cnt[1])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"><%=Util.parseDecimal(c3_ave*p_cnt[2])%></td>
							            <td class='title title_border' style="text-align:right"></td>
							            <td class='title title_border' style="text-align:right"></td>
							          </tr>	
		<% } else { %>		
		 						      <tr> 
							            <td class='title title_border' colspan="15" align="center">데이타가 없습니다.</td>                
							     
							          </tr>	
		<% } %> 			             
					            </table>			            
					            
			         	 	</div>  
			        	</td>
			   		 </tr>
			   	 </table>
			</div>
		</div> 
	</td>
  </tr>		 					
</table>
</form>

<script language="JavaScript">
  	 

</script>

</body>
</html>
