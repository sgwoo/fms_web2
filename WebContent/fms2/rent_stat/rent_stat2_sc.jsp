<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String start_dt = request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");	
	
	
	
	String car_kd_nm[]	 	= new String[5];
	car_kd_nm[0] = "소형";
	car_kd_nm[1] = "중형";
	car_kd_nm[2] = "대형";
	car_kd_nm[3] = "기타";
	car_kd_nm[4] = "소계";
	

	String br_id_nm[]	 	= new String[6];
	br_id_nm[0] = "본사";
	br_id_nm[1] = "부산지점";
	br_id_nm[2] = "대전지점";
	br_id_nm[3] = "강남지점";
	br_id_nm[4] = "대구지점";
	br_id_nm[5] = "광주지점";

	String br_id_cd[]	 	= new String[6];
	br_id_cd[0] = "S1";
	br_id_cd[1] = "B1";
	br_id_cd[2] = "D1";
	br_id_cd[3] = "S2";
	br_id_cd[4] = "G1";
	br_id_cd[5] = "J1";

	
	int cnt1[]	 			= new int[5];
	int cnt2[]	 			= new int[5];
					
	int amt1[]	 			= new int[5];
	int amt2[]	 			= new int[5];
	int amt3[]	 			= new int[5];	
	int amt4[]	 			= new int[5];		


	int h_cnt1[]	 			= new int[7];
	int h_cnt2[]	 			= new int[7];

	int h_amt1[]	 			= new int[7];
	int h_amt2[]	 			= new int[7];
	int h_amt3[]	 			= new int[7];	
	int h_amt4[]	 			= new int[7];		

	int t_cnt1[]	 			= new int[5];
	int t_cnt2[]	 			= new int[5];

	int t_amt1[]	 			= new int[5];
	int t_amt2[]	 			= new int[5];
	int t_amt3[]	 			= new int[5];	
	int t_amt4[]	 			= new int[5];		
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//세부리스트
	function view_stat2(s_br, s_br_nm, car_kd, car_kd_nm, st, st_nm){
		window.open('rent_stat2_list.jsp?gubun4=<%=gubun4%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_br='+s_br+'&s_br_nm='+s_br_nm+'&car_kd='+car_kd+'&car_kd_nm='+car_kd_nm+'&st='+st+'&st_nm='+st_nm, "STAT2_LIST", "left=0, top=0, width=900, height=568, scrollbars=yes, status=yes, resize");
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='start_dt' 		value='<%=start_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="3" colspan="2" class=title>구분</td>
                    <td colspan="4" class=title>신규계약</td>
                    <td colspan="4" class=title>연장계약</td>
                    <td colspan="4" class=title>합계</td>
                </tr>
                <tr> 
                    <td rowspan="2" width=5% class=title>건수</td>
                    <td colspan="3" class=title>계약고</td>					
                    <td rowspan="2" width=5% class=title>건수</td>
                    <td colspan="3" class=title>계약고</td>					
                    <td rowspan="2" width=5% class=title>건수</td>
                    <td colspan="3" class=title>계약고</td>					
                </tr>                
                <tr> 
                    <td width=8% class=title>매출</td>
                    <td width=8% class=title>미도래</td>				
                    <td width=8% class=title>소계</td>
                    <td width=8% class=title>매출</td>
                    <td width=8% class=title>미도래</td>				
                    <td width=8% class=title>소계</td>
                    <td width=8% class=title>매출</td>
                    <td width=8% class=title>미도래</td>				
                    <td width=8% class=title>소계</td>
                </tr> 
                
                <!--지점순-->
		<%	for(int k = 0 ; k < 6 ; k++){
                		h_cnt1[k] = 0;
                		h_cnt2[k] = 0;
                		h_amt1[k] = 0;
                		h_amt2[k] = 0;
                		h_amt3[k] = 0;
                		h_amt4[k] = 0;					
		%>
                
                <%
                	//초기화
                	for (int j = 0 ; j < 4 ; j++){
				cnt1[j] = 0;
				cnt2[j] = 0;
				amt1[j] = 0;
				amt2[j] = 0;
				amt3[j] = 0;
				amt4[j] = 0;								
			}
                %>  	                    
                
		<!--본사,부산,대전,강남,대구,광주-->
		<%	Vector vt = rs_db.getRentStat2List(br_id_cd[k], gubun4, start_dt, end_dt);
			int vt_size = vt.size();			
		%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
								
				if(String.valueOf(ht.get("CAR_KD")).equals("1")){													
					cnt1[0] = AddUtil.parseInt((String)ht.get("CNT1"));
					cnt2[0] = AddUtil.parseInt((String)ht.get("CNT2"));
					amt1[0] = AddUtil.parseInt((String)ht.get("AMT1_1"));
					amt2[0] = AddUtil.parseInt((String)ht.get("AMT1_2"));
					amt3[0] = AddUtil.parseInt((String)ht.get("AMT2_1"));
					amt4[0] = AddUtil.parseInt((String)ht.get("AMT2_2"));
				}						
				if(String.valueOf(ht.get("CAR_KD")).equals("2")){
					cnt1[1] = AddUtil.parseInt((String)ht.get("CNT1"));
					cnt2[1] = AddUtil.parseInt((String)ht.get("CNT2"));
					amt1[1] = AddUtil.parseInt((String)ht.get("AMT1_1"));
					amt2[1] = AddUtil.parseInt((String)ht.get("AMT1_2"));
					amt3[1] = AddUtil.parseInt((String)ht.get("AMT2_1"));
					amt4[1] = AddUtil.parseInt((String)ht.get("AMT2_2"));
				}
				if(String.valueOf(ht.get("CAR_KD")).equals("3")){
					cnt1[2] = AddUtil.parseInt((String)ht.get("CNT1"));
					cnt2[2] = AddUtil.parseInt((String)ht.get("CNT2"));					
					amt1[2] = AddUtil.parseInt((String)ht.get("AMT1_1"));
					amt2[2] = AddUtil.parseInt((String)ht.get("AMT1_2"));
					amt3[2] = AddUtil.parseInt((String)ht.get("AMT2_1"));
					amt4[2] = AddUtil.parseInt((String)ht.get("AMT2_2"));
				}
				if(String.valueOf(ht.get("CAR_KD")).equals("4")){
					cnt1[3] = AddUtil.parseInt((String)ht.get("CNT1"));
					cnt2[3] = AddUtil.parseInt((String)ht.get("CNT2"));
					amt1[3] = AddUtil.parseInt((String)ht.get("AMT1_1"));
					amt2[3] = AddUtil.parseInt((String)ht.get("AMT1_2"));
					amt3[3] = AddUtil.parseInt((String)ht.get("AMT2_1"));
					amt4[3] = AddUtil.parseInt((String)ht.get("AMT2_2"));
				}			
			}%>
					                
                <%	for(int i = 0 ; i < 4 ; i++){
                		h_cnt1[k] = h_cnt1[k]+cnt1[i];
                		h_cnt2[k] = h_cnt2[k]+cnt2[i];
                		h_amt1[k] = h_amt1[k]+amt1[i];
                		h_amt2[k] = h_amt2[k]+amt2[i];
                		h_amt3[k] = h_amt3[k]+amt3[i];
                		h_amt4[k] = h_amt4[k]+amt4[i];
                		t_cnt1[i] = t_cnt1[i]+cnt1[i];
                		t_cnt2[i] = t_cnt2[i]+cnt2[i];
                		t_amt1[i] = t_amt1[i]+amt1[i];
                		t_amt2[i] = t_amt2[i]+amt2[i];
                		t_amt3[i] = t_amt3[i]+amt3[i];
                		t_amt4[i] = t_amt4[i]+amt4[i];%>           
                <tr> 
                    <%if(i==0){%><td align='center' rowspan='5'><%=br_id_nm[k]%></td><%}%>
                    <td align='center'><%=car_kd_nm[i]%></td>
                    <td align='center'><a href="javascript:view_stat2('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','<%=i+1%>','<%=car_kd_nm[i]%>','1','신규계약')"><%=cnt1[i]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt1[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt2[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt1[i]+amt2[i])%></td>
                    <td align='center'><a href="javascript:view_stat2('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','<%=i+1%>','<%=car_kd_nm[i]%>','2','연장계약')"><%=cnt2[i]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt3[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt4[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt3[i]+amt4[i])%></td>
                    <td align='center'><%=cnt1[i]+cnt2[i]%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt1[i]+amt3[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt2[i]+amt4[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt1[i]+amt3[i]+amt2[i]+amt4[i])%></td>
                </tr>   
                <%	}%> 	                		                                    				
                <tr>                     
                    <td align='center'><%=car_kd_nm[4]%></td>
                    <td align='center'><a href="javascript:view_stat2('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','','','1','신규계약')"><%=h_cnt1[k]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt1[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt2[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt1[k]+h_amt2[k])%></td>
                    <td align='center'><a href="javascript:view_stat2('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','','','2','연장계약')"><%=h_cnt2[k]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt3[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt4[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt3[k]+h_amt4[k])%></td>
                    <td align='center'><%=h_cnt1[k]+h_cnt2[k]%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt1[k]+h_amt3[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt2[k]+h_amt4[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt1[k]+h_amt2[k]+h_amt3[k]+h_amt4[k])%></td>
                </tr>  
                
		<%}%>
                
                <%
                	//초기화
                	for (int j = 0 ; j < 4 ; j++){
				cnt1[j] = 0;
				cnt2[j] = 0;
				amt1[j] = 0;
				amt2[j] = 0;
				amt3[j] = 0;
				amt4[j] = 0;								
			}
                %>  
                
                
		<!--합계--> 
		
                <%	for(int i = 0 ; i < 4 ; i++){
                		t_cnt1[4] = t_cnt1[4]+t_cnt1[i];
                		t_cnt2[4] = t_cnt2[4]+t_cnt2[i];
                		t_amt1[4] = t_amt1[4]+t_amt1[i];
                		t_amt2[4] = t_amt2[4]+t_amt2[i];
                		t_amt3[4] = t_amt3[4]+t_amt3[i];
                		t_amt4[4] = t_amt4[4]+t_amt4[i];
                		%>           
                <tr> 
                    <%if(i==0){%><td align='center' rowspan='5'>합계</td><%}%>
                    <td align='center'><%=car_kd_nm[i]%></td>
                    <td align='center'><a href="javascript:view_stat2('','','<%=i+1%>','<%=car_kd_nm[i]%>','1','신규계약')"><%=t_cnt1[i]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt2[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[i]+t_amt2[i])%></td>
                    <td align='center'><a href="javascript:view_stat2('','','<%=i+1%>','<%=car_kd_nm[i]%>','2','연장계약')"><%=t_cnt2[i]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt3[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt4[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt3[i]+t_amt4[i])%></td>
                    <td align='center'><%=t_cnt1[i]+t_cnt2[i]%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[i]+t_amt3[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt2[i]+t_amt4[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[i]+t_amt3[i]+t_amt2[i]+t_amt4[i])%></td>
                </tr>   
                <%	}%> 	                		                                    				
                <tr>                     
                    <td align='center'><%=car_kd_nm[4]%></td>
                    <td align='center'><a href="javascript:view_stat2('','','','','1','신규계약')"><%=t_cnt1[4]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt2[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[4]+t_amt2[4])%></td>
                    <td align='center'><a href="javascript:view_stat2('','','','','2','연장계약')"><%=t_cnt2[4]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt3[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt4[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt3[4]+t_amt4[4])%></td>
                    <td align='center'><%=t_cnt1[4]+t_cnt2[4]%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[4]+t_amt3[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt2[4]+t_amt4[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[4]+t_amt2[4]+t_amt3[4]+t_amt4[4])%></td>
                </tr>  		               	                                             

            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>