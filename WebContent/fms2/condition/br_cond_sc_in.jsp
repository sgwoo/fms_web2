<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	CommonDataBase c_db = CommonDataBase.getInstance();
	ConditionDatabase cd_db = ConditionDatabase.getInstance();
	
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트
	int brch_size 	= branches.size();
		
	//영업소 갯수
	int br_size = brch_size;
	
	String br_id_nm[]	 = new String[br_size];
	String br_id_cd[]	 = new String[br_size];
	
	if(brch_size > 0){
    		for (int i = 0 ; i < brch_size ; i++){
    			Hashtable branch = (Hashtable)branches.elementAt(i);
    			
    			br_id_nm[i] = String.valueOf(branch.get("BR_NM"));
    			br_id_cd[i] = String.valueOf(branch.get("BR_ID"));
    		}
    	}	
    		

	

	//소계
	int cnt[]	 = new int[18];
	int u_cnt[]	 = new int[2];
	//합계
	int t_cnt1[]	 = new int[18];
	int t_cnt2[]	 = new int[18];
	int t_cnt3[]	 = new int[18];
	int t_cnt4[]	 = new int[18];
	int ut_cnt1[]	 = new int[2];
	int ut_cnt2[]	 = new int[2];
	int ut_cnt3[]	 = new int[2];
	int ut_cnt4[]	 = new int[2];	

	Vector vt = new Vector();
	int vt_size = 0;
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="6%" rowspan="3" class=title>구분</td>
                    <td colspan=2 class=title>근무자현황</td>
                    <td width="1%" rowspan="<%=3+(brch_size*4)+4%>">&nbsp;</td>
                    <td colspan="19" class=title>영업현황</td>
                </tr>
                <tr>
                  <td width="6%" rowspan="2" class=title>구분</td>
                  <td width="9%" rowspan="2" class=title>영업현황/인원<br>(평균)</td>
                  <td width="6%" rowspan="2" class=title>구분</td>
                  <!--<td width="3%" rowspan="2" class=title>영업<br>현황</td>-->
                  <td colspan=6 class=title>일반식</td>
                  <td colspan=6 class=title>기본식</td>
                  <td colspan=6 class=title>합계</td>
                </tr>
                <tr>
                  <td width=4% class=title>12개월</td>
                    <td width=4% class=title>24개월</td>
                    <td width=4% class=title>36개월</td>
                    <td width=4% class=title>48개월</td>
                    <td width=4% class=title>기타</td>
                    <td width=4% class=title>소계</td>
                    <td width=4% class=title>12개월</td>
                    <td width=4% class=title>24개월</td>
                    <td width=4% class=title>36개월</td>
                    <td width=4% class=title>48개월</td>
                    <td width=4% class=title>기타</td>
                    <td width=4% class=title>소계</td>
                    <td width=4% class=title>12개월</td>
                    <td width=4% class=title>24개월</td>
                    <td width=4% class=title>36개월</td>
                    <td width=4% class=title>48개월</td>
                    <td width=4% class=title>기타</td>
                    <td width=4% class=title>합계</td>
		</tr>		
		
		
                <%for (int k = 0 ; k < brch_size ; k++){//본사,강남지점,인천지점,수원지점,대구지점,대전지점,부산지점,광주지점%>	
                
                
                
		<%
			//초기화
			for (int j = 0 ; j < 18; j++){
				cnt[j] = 0;
			}
		%>
		
		<%	
			vt = cd_db.getBrCondStatList("bus_st", br_id_cd[k], gubun1, gubun2, st_dt, end_dt);
			vt_size = vt.size();
			
			Hashtable s_ht1 = new Hashtable();
			Hashtable s_ht2 = new Hashtable();
			Hashtable s_ht3 = new Hashtable();
									
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				if(String.valueOf(ht.get("BUS_ST_NM")).equals("자체영업")) s_ht1 = ht;
				if(String.valueOf(ht.get("BUS_ST_NM")).equals("영업사원")) s_ht2 = ht;
				if(String.valueOf(ht.get("BUS_ST_NM")).equals("에이전트")) s_ht3 = ht;
				
				for (int j = 0 ; j < 18; j++){
					//소계
					cnt[j] 	= cnt[j] + AddUtil.parseInt((String)ht.get("CNT"+(j+1)));
					//합계
					if(String.valueOf(ht.get("BUS_ST")).equals("1"))	t_cnt1[j] 	= t_cnt1[j] + AddUtil.parseInt((String)ht.get("CNT"+(j+1)));
					if(String.valueOf(ht.get("BUS_ST")).equals("2"))	t_cnt2[j] 	= t_cnt2[j] + AddUtil.parseInt((String)ht.get("CNT"+(j+1)));
					if(String.valueOf(ht.get("BUS_ST")).equals("7"))	t_cnt3[j] 	= t_cnt3[j] + AddUtil.parseInt((String)ht.get("CNT"+(j+1)));										 							
					t_cnt4[j] 	= t_cnt4[j] + AddUtil.parseInt((String)ht.get("CNT"+(j+1)));					
				}
			}
			
			vt = cd_db.getBrCondStatList("dept_cont", br_id_cd[k], gubun1, gubun2, st_dt, end_dt);
			vt_size = vt.size();
			
			Hashtable u_ht = new Hashtable();
			
			for(int i = 0 ; i < vt_size ; i++){
				u_ht = (Hashtable)vt.elementAt(i);	
				
				ut_cnt1[1] 	= ut_cnt1[1] + AddUtil.parseInt((String)u_ht.get("L_CNT1"));
				ut_cnt2[1] 	= ut_cnt2[1] + AddUtil.parseInt((String)u_ht.get("L_CNT2"));
				ut_cnt3[1] 	= ut_cnt3[1] + AddUtil.parseInt((String)u_ht.get("L_CNT3"));
			}	
			
			vt = cd_db.getBrCondStatList("dept_user", br_id_cd[k], gubun1, gubun2, st_dt, end_dt);
			vt_size = vt.size();
			
			Hashtable u_ht2 = new Hashtable();
			
			for(int i = 0 ; i < vt_size ; i++){
				u_ht2 = (Hashtable)vt.elementAt(i);	
				
				ut_cnt1[0] 	= ut_cnt1[0] + AddUtil.parseInt((String)u_ht2.get("U_CNT1"));
				ut_cnt2[0] 	= ut_cnt2[0] + AddUtil.parseInt((String)u_ht2.get("U_CNT2"));
				ut_cnt3[0] 	= ut_cnt3[0] + AddUtil.parseInt((String)u_ht2.get("U_CNT3"));
			}						
								
                %>
		<tr>
		    <td align="center" rowspan='4'><%=br_id_nm[k]%><br>(<%=br_id_cd[k]%>)</td>					
		    <td align="center">영업담당</td>
		    <td align="center"><%=u_ht.get("L_CNT1")%>/<%=u_ht2.get("U_CNT1")%><%if(AddUtil.parseInt((String)u_ht.get("L_CNT1"))>0 && AddUtil.parseInt((String)u_ht2.get("U_CNT1"))>0){%>&nbsp;(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat((String)u_ht.get("L_CNT1")) / AddUtil.parseFloat((String)u_ht2.get("U_CNT1")),1)%>)<%}else{%>&nbsp;(0.0)<%}%></td>		    
		    <td align="center">자체영업</td>
		    <%for (int j = 0 ; j < 18; j++){%>
		    <td align="center"><%=s_ht1.get("CNT"+(j+1))==null?"0":s_ht1.get("CNT"+(j+1))%></td>
		    <%}%>
		</tr>              
		<tr>
		    <td align="center">고객지원</td>
		    <td align="center"><%=u_ht.get("L_CNT2")%>/<%=u_ht2.get("U_CNT2")%><%if(AddUtil.parseInt((String)u_ht.get("L_CNT2"))>0 && AddUtil.parseInt((String)u_ht2.get("U_CNT2"))>0){%>&nbsp;(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat((String)u_ht.get("L_CNT2")) / AddUtil.parseFloat((String)u_ht2.get("U_CNT2")),1)%>)<%}else{%>&nbsp;(0.0)<%}%></td>		    
		    <td align="center">영업사원</td>
		    <%for (int j = 0 ; j < 18; j++){%>
		    <td align="center"><%=s_ht2.get("CNT"+(j+1))==null?"0":s_ht2.get("CNT"+(j+1))%></td>
		    <%}%>
		</tr>          
		<tr>
		    <td align="center">사무/관리</td>
		    <td align="center"><%=u_ht.get("L_CNT3")%>/<%=u_ht2.get("U_CNT3")%><%if(AddUtil.parseInt((String)u_ht.get("L_CNT3"))>0 && AddUtil.parseInt((String)u_ht2.get("U_CNT3"))>0){%>&nbsp;(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat((String)u_ht.get("L_CNT3")) / AddUtil.parseFloat((String)u_ht2.get("U_CNT3")),1)%>)<%}else{%>&nbsp;(0.0)<%}%></td>		    
		    <td align="center">에이전트</td>
		    <%for (int j = 0 ; j < 18; j++){%>
		    <td align="center"><%=s_ht3.get("CNT"+(j+1))==null?"0":s_ht3.get("CNT"+(j+1))%></td>
		    <%}%>
		</tr>        		 		                  
                
                
                <!--소계-->
		<tr>		    
		    <td class=title>소계</td>
		    <td class=title><%=u_ht.get("L_CNT0")%>/<%=u_ht2.get("U_CNT0")%><%if(AddUtil.parseInt((String)u_ht.get("L_CNT0"))>0 && AddUtil.parseInt((String)u_ht2.get("U_CNT0"))>0){%>&nbsp;(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat((String)u_ht.get("L_CNT0")) / AddUtil.parseFloat((String)u_ht2.get("U_CNT0")),1)%>)<%}else{%>&nbsp;(0.0)<%}%></td>		    
		    <td class=title>소계</td>
		    <%for (int j = 0 ; j < 18; j++){%>
		    <td class=title><%=cnt[j]%></td>
		    <%}%>
		</tr>     

		
		                            
		
                <%}%>
                
                
                
                
                
                
                <!--합계-->
		<tr>		    
		    <td class=title rowspan='4'>합계</td>
		    <td class=title>영업담당</td>
		    <td class=title><%=ut_cnt1[1]%>/<%=ut_cnt1[0]%><%if(ut_cnt1[1]>0){%>&nbsp;(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ut_cnt1[1])) / AddUtil.parseFloat(String.valueOf(ut_cnt1[0])),1)%>)<%}else{%>&nbsp;(0.0)<%}%></td>		    
		    <td class=title>자체영업</td>
		    <%for (int j = 0 ; j < 18; j++){%>
		    <td class=title><%=t_cnt1[j]%></td>
		    <%}%>
		</tr>          
		<tr>		    
		    <td class=title>고객지원</td>
		    <td class=title><%=ut_cnt2[1]%>/<%=ut_cnt2[0]%><%if(ut_cnt2[1]>0){%>&nbsp;(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ut_cnt2[1])) / AddUtil.parseFloat(String.valueOf(ut_cnt2[0])),1)%>)<%}else{%>&nbsp;(0.0)<%}%></td>
		    <td class=title>영업사원</td>
		    <%for (int j = 0 ; j < 18; j++){%>
		    <td class=title><%=t_cnt2[j]%></td>
		    <%}%>
		</tr>       
		<tr>		    
		    <td class=title>에이전트</td>
		    <td class=title><%=t_cnt3[18-1]%>/-&nbsp;(0)</td>
		    <td class=title>에이전트</td>
		    <%for (int j = 0 ; j < 18; j++){%>
		    <td class=title><%=t_cnt3[j]%></td>
		    <%}%>
		</tr>    
		<tr>		    
		    <td class=title>합계</td>		    
		    <td class=title><%=ut_cnt1[1]+ut_cnt2[1]+t_cnt3[18-1]%>/<%=ut_cnt1[0]+ut_cnt2[0]%><%if(ut_cnt1[0]+ut_cnt2[0]>0){%>&nbsp;(<%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ut_cnt1[1]+ut_cnt2[1]+t_cnt3[18-1])) / AddUtil.parseFloat(String.valueOf(ut_cnt1[0]+ut_cnt2[0])),1)%>)<%}else{%>&nbsp;(0.0)<%}%></td>
		    <td class=title>합계</td>
		    <%for (int j = 0 ; j < 18; j++){%>
		    <td class=title><%=t_cnt4[j]%></td>
		    <%}%>
		</tr>  	
			   
			   				          
            </table>
        </td>            		            		
	</tr>
	<tr>
	    <td>* 근무인원수는 현재기준입니다. (대표이사, 팀장은 제외), 근무자현황-영업현황 최종 합계에는 에이전트 계약분 포함되어 있음. </td>
	</tr>
</table>


</body>
</html>