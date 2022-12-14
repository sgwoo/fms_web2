<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String start_dt = request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트
	int brch_size 	= branches.size();	
		
	//지점수
	int br_size = brch_size;
	
	//차종수
	int kd_size = 4;
	
	
	String car_kd_nm[]	 = new String[kd_size+1];
	car_kd_nm[0] = "소형";
	car_kd_nm[1] = "중형";
	car_kd_nm[2] = "대형";
	car_kd_nm[3] = "기타";
	car_kd_nm[4] = "소계";
	
	
	String br_id_nm[]	 = new String[br_size];
	String br_id_cd[]	 = new String[br_size];
	
	if(brch_size > 0){
    		for (int i = 0 ; i < brch_size ; i++){
    			Hashtable branch = (Hashtable)branches.elementAt(i);
    			
    			br_id_nm[i] = String.valueOf(branch.get("BR_NM"));
    			br_id_cd[i] = String.valueOf(branch.get("BR_ID"));
    		}
    	}	
	
	
	int cnt1[]	 	= new int[kd_size+1];
	int cnt2[]	 	= new int[kd_size+1];
	int cnt3[]	 	= new int[kd_size+1];
		
					
	int h_cnt1[]	 	= new int[br_size];
	int h_cnt2[]	 	= new int[br_size];
	int h_cnt3[]	 	= new int[br_size];


	int t_cnt1[]	 	= new int[kd_size+1];
	int t_cnt2[]	 	= new int[kd_size+1];
	int t_cnt3[]	 	= new int[kd_size+1];

	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//세부리스트
	function view_stat4(s_br, s_br_nm, car_kd, car_kd_nm, st, st_nm){
		window.open('rm_stat4_list.jsp?gubun4=<%=gubun4%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_br='+s_br+'&s_br_nm='+s_br_nm+'&car_kd='+car_kd+'&car_kd_nm='+car_kd_nm+'&st='+st+'&st_nm='+st_nm, "STAT4_LIST", "left=0, top=0, width=900, height=568, scrollbars=yes, status=yes, resize");
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
                    <td colspan="5" class=title>대여종료</td>
                </tr>
                <tr> 
                    <td colspan="3" class=title>반차완료</td>
                    <td rowspan="2" width=15% class=title>미반차</td>					
                    <td rowspan="2" width=15% class=title>합계</td>
                </tr>                
                <tr> 
                    <td width=15% class=title>중도해지</td>
                    <td width=15% class=title>만기해지</td>				
                    <td width=15% class=title>소계</td>				
                </tr>  
                
                <!--지점순-->
		<%	for(int k = 0 ; k < br_size ; k++){
                		//소계 초기화
                		h_cnt1[k] = 0;                		
                		h_cnt2[k] = 0;
                		h_cnt3[k] = 0;                		
		%>
		
                 <%
	                	//항목 초기화
        	        	for (int j = 0 ; j < kd_size ; j++){
					cnt1[j] = 0;
					cnt2[j] = 0;
					cnt3[j] = 0;
				}
                %>  	 
                	                
		<!--본사,부산,대전,강남,대구,광주,인천,수원-->
		<%		Vector vt = rs_db.getRmRentStat4List(br_id_cd[k], gubun4, start_dt, end_dt);
				int vt_size = vt.size();			
		%>
		<%		//배열에 값 넘김	
				for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					//소형					
					if(String.valueOf(ht.get("CAR_KD")).equals("1")){													
						cnt1[0] = AddUtil.parseInt((String)ht.get("CNT1"));
						cnt2[0] = AddUtil.parseInt((String)ht.get("CNT2"));
						cnt3[0] = AddUtil.parseInt((String)ht.get("CNT3"));
					}						
					//중형	
					if(String.valueOf(ht.get("CAR_KD")).equals("2")){
						cnt1[1] = AddUtil.parseInt((String)ht.get("CNT1"));
						cnt2[1] = AddUtil.parseInt((String)ht.get("CNT2"));
						cnt3[1] = AddUtil.parseInt((String)ht.get("CNT3"));
					}
					//대형
					if(String.valueOf(ht.get("CAR_KD")).equals("3")){
						cnt1[2] = AddUtil.parseInt((String)ht.get("CNT1"));
						cnt2[2] = AddUtil.parseInt((String)ht.get("CNT2"));					
						cnt3[2] = AddUtil.parseInt((String)ht.get("CNT3"));
					}
					//기타
					if(String.valueOf(ht.get("CAR_KD")).equals("4")){
						cnt1[3] = AddUtil.parseInt((String)ht.get("CNT1"));
						cnt2[3] = AddUtil.parseInt((String)ht.get("CNT2"));
						cnt3[3] = AddUtil.parseInt((String)ht.get("CNT3"));
					}			
				}
		%>
					                
                <%		for(int i = 0 ; i < kd_size ; i++){
	                		//소계,합계
	                		h_cnt1[k] = h_cnt1[k]+cnt1[i];
        	        		h_cnt2[k] = h_cnt2[k]+cnt2[i];
                			h_cnt3[k] = h_cnt3[k]+cnt3[i];
                			t_cnt1[i] = t_cnt1[i]+cnt1[i];
                			t_cnt2[i] = t_cnt2[i]+cnt2[i];
	                		t_cnt3[i] = t_cnt3[i]+cnt3[i];                		
                %>           
                <!--소형,중형,대형,기타-->
                <tr> 
                    <%if(i==0){%><td align='center' rowspan='5'><%=br_id_nm[k]%></td><%}%>
                    <td align='center'><%=car_kd_nm[i]%></td>
                    <td align='center'><a href="javascript:view_stat4('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','<%=i+1%>','<%=car_kd_nm[i]%>','1','중도해지')"><%=cnt1[i]%></a></td>
                    <td align='center'><a href="javascript:view_stat4('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','<%=i+1%>','<%=car_kd_nm[i]%>','2','만기해지')"><%=cnt2[i]%></a></td>
                    <td align='center'><%=cnt1[i]+cnt2[i]%></td>
                    <td align='center'><a href="javascript:view_stat4('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','<%=i+1%>','<%=car_kd_nm[i]%>','3','미반차')"><%=cnt3[i]%></a></td>                    
                    <td align='center'><%=cnt1[i]+cnt2[i]+cnt3[i]%></td>
                </tr>   
                <%		}%> 	                		                                    				
                <!--소계-->	  
                <tr>                     
                    <td align='center'><%=car_kd_nm[4]%></td>
                    <td align='center'><a href="javascript:view_stat4('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','','','1','중도해지')"><%=h_cnt1[k]%></a></td>
                    <td align='center'><a href="javascript:view_stat4('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','','','2','만기해지')"><%=h_cnt2[k]%></a></td>
                    <td align='center'><%=h_cnt1[k]+h_cnt2[k]%></td>                    
                    <td align='center'><a href="javascript:view_stat4('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','','','3','미반차')"><%=h_cnt3[k]%></a></td>                    
                    <td align='center'><%=h_cnt1[k]+h_cnt2[k]+h_cnt3[k]%></td>                    
                </tr>  
                
                <%	}%>
                
                
                
		<!--합계--> 
		
                <%	for(int i = 0 ; i < kd_size ; i++){
                		t_cnt1[4] = t_cnt1[4]+t_cnt1[i];
                		t_cnt2[4] = t_cnt2[4]+t_cnt2[i];
                		t_cnt3[4] = t_cnt3[4]+t_cnt3[i];
                %>           
                <tr> 
                    <%if(i==0){%><td align='center' rowspan='5'>합계</td><%}%>
                    <td align='center'><%=car_kd_nm[i]%></td>
                    <td align='center'><a href="javascript:view_stat4('','','<%=i+1%>','<%=car_kd_nm[i]%>','1','중도해지')"><%=t_cnt1[i]%></a></td>
                    <td align='center'><a href="javascript:view_stat4('','','<%=i+1%>','<%=car_kd_nm[i]%>','2','만기해지')"><%=t_cnt2[i]%></a></td>
                    <td align='center'><%=t_cnt1[i]+t_cnt2[i]%></td>
                    <td align='center'><a href="javascript:view_stat4('','','<%=i+1%>','<%=car_kd_nm[i]%>','3','미반차')"><%=t_cnt3[i]%></a></td>                    
                    <td align='center'><%=t_cnt1[i]+t_cnt2[i]+t_cnt3[i]%></td>
                </tr>   
                <%	}%> 	                		                                    				
                <tr>                     
                    <td align='center'><%=car_kd_nm[4]%></td>
                    <td align='center'><a href="javascript:view_stat4('','','','','1','중도해지')"><%=t_cnt1[4]%></a></td>
                    <td align='center'><a href="javascript:view_stat4('','','','','2','만기해지')"><%=t_cnt2[4]%></a></td>
                    <td align='center'><%=t_cnt1[4]+t_cnt2[4]%></td>
                    <td align='center'><a href="javascript:view_stat4('','','','','3','미반차')"><%=t_cnt3[4]%></a></td>                    
                    <td align='center'><%=t_cnt1[4]+t_cnt2[4]+t_cnt3[4]%></td>
                </tr>  		               	                                             

            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>