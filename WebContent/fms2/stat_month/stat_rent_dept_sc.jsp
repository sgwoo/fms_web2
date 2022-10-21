<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*" %>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	//총갯수
	int size = 16; //20160307 울산은 대구로 넣는다. 17->16

	int cnt0[]	 = new int[size];
	int cnt1[]	 = new int[size];	
	int cnt2[]	 = new int[size];

	int t_cnt0[]	 = new int[size];
	int t_cnt1[]	 = new int[size];	
	int t_cnt2[]	 = new int[size];



%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function open_rent_dept(mode, rent_way, br_id, dept_id){
		//return;
		var SUBWIN="stat_rent_dept_list.jsp?mode="+mode+"&rent_way="+rent_way+"&br_id="+br_id+"&dept_id="+dept_id+"&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>";	
		window.open(SUBWIN, "StatRentDept"+mode+""+rent_way, "left=10, top=10, width=800, height=600, scrollbars=yes");
	}

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=80+80+(80*11)%>>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td colspan="2" rowspan="2" class=title>구분</td>
                    <td colspan="3" class=title>본사</td>		    
                    <td width=80 rowspan="2" class=title>부산지점</td>		    
                    <td width=80 rowspan="2" class=title>대전지점</td>		    
                    <td width=80 rowspan="2" class=title>강남지점</td>		    
                    <td width=80 rowspan="2" class=title>광주지점</td>		    
                    <td width=80 rowspan="2" class=title>대구지점</td>		    
                    <td width=80 rowspan="2" class=title>인천지점</td>		    
                    <td width=80 rowspan="2" class=title>수원지점</td>		    
					<td width=80 rowspan="2" class=title>강서지점</td>
					<td width=80 rowspan="2" class=title>구로지점</td>
					<!--<td width=80 rowspan="2" class=title>울산지점</td>-->
					<td width=80 rowspan="2" class=title>광화문지점</td>
					<td width=80 rowspan="2" class=title>송파지점</td>
					<td width=80 rowspan="2" class=title>에이전트</td>
                    <td width=80 rowspan="2" class=title>합계</td>		                        
                </tr>
                <tr align="center"> 
                    <td width=80 class=title>영업팀</td>		    
                    <td width=80 class=title>고객지원팀</td>		                        
                    <td width=80 class=title>소계</td>		                        
                </tr>
                
		<!--신차-->
		<%	Vector vt = sb_db.getStatDeptList("1", gubun1, st_dt, end_dt);
			int vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for (int j = 0 ; j < size ; j++){
					if(String.valueOf(ht.get("RENT_WAY")).equals("기본식")){
						cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						
						t_cnt1[j] = t_cnt1[j]+ cnt1[j];
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){
						cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						
						t_cnt2[j] = t_cnt2[j]+ cnt2[j];
					}
				}
		%>
                <tr> 
                    <%if(i==0){%><td width="80" rowspan="3" align="center"><%=ht.get("CAR_GU")%></td><%}%>
                    <td width="80" align="center"><%=ht.get("RENT_WAY")%></td>					
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S1','0001')"><%=ht.get("CNT0")%></a></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S1','0002')"><%=ht.get("CNT1")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S1','')"><%=ht.get("CNT2")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','B1','0007')"><%=ht.get("CNT3")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','D1','0008')"><%=ht.get("CNT4")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S2','0009')"><%=ht.get("CNT5")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','J1','0010')"><%=ht.get("CNT6")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','G1','0011')"><%=ht.get("CNT7")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','I1','0012')"><%=ht.get("CNT8")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','K3','0013')"><%=ht.get("CNT9")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S3','0014')"><%=ht.get("CNT10")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S4','0015')"><%=ht.get("CNT11")%></td>
		    <!--<td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','U1','0016')"><%=ht.get("CNT12")%></td>-->
		    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S5','0017')"><%=ht.get("CNT12")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S6','0018')"><%=ht.get("CNT13")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','S1','1000')"><%=ht.get("CNT14")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('1','<%=ht.get("RENT_WAY")%>','','')"><%=ht.get("CNT15")%></td>                    					
                </tr>		
		<%	}%>	
		
		<!--신차 결과가 2개 아닐때-->
		<%	if(vt_size<2){
				for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><td width="80" rowspan="3" align="center">신차</td><%}%>
                    <td width="80" align="center"><%if(cnt1[5]==0 && i==0){%>기본식<%}else{%>일반식<%}%></td>
			<%	for (int j = 0 ; j < size ; j++){%>	
                    <td align="right"><%=0%></td>
			<%	}%>
                </tr>						
		<%		}
			}%>			
			
                <tr> 
                    <td width="80" class=title>소계</td>
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] 	= cnt1[j]+cnt2[j];
				t_cnt0[j] 	= t_cnt0[j]+cnt0[j];
							
			%>
                    <td class=title style='text-align:right'><%=cnt0[j]%></td>
			<%}%>
                </tr>			
			
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = 0;
				cnt1[j] = 0;
				cnt2[j] = 0;
			}%>
			
		<!--재리스-->
		<%	vt = sb_db.getStatDeptList("2", gubun1, st_dt, end_dt);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for (int j = 0 ; j < size ; j++){
					if(String.valueOf(ht.get("RENT_WAY")).equals("기본식")){
						cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt1[j] = t_cnt1[j]+ cnt1[j];
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){
						cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt2[j] = t_cnt2[j]+ cnt2[j];
					}
				}
		%>
                <tr> 
                    <%if(i==0){%><td width="80" rowspan="3" align="center"><%=ht.get("CAR_GU")%></td><%}%>
                    <td width="80" align="center"><%=ht.get("RENT_WAY")%></td>					
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S1','0001')"><%=ht.get("CNT0")%></a></td>
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S1','0002')"><%=ht.get("CNT1")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S1','')"><%=ht.get("CNT2")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','B1','0007')"><%=ht.get("CNT3")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','D1','0008')"><%=ht.get("CNT4")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S2','0009')"><%=ht.get("CNT5")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','J1','0010')"><%=ht.get("CNT6")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','G1','0011')"><%=ht.get("CNT7")%></td>                    
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','I1','0012')"><%=ht.get("CNT8")%></td>                    
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','K3','0011')"><%=ht.get("CNT9")%></td>                    
		    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S3','0014')"><%=ht.get("CNT10")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S4','0015')"><%=ht.get("CNT11")%></td>
		    <!--<td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','U1','0016')"><%=ht.get("CNT12")%></td>-->
		    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S5','0017')"><%=ht.get("CNT12")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S6','0018')"><%=ht.get("CNT13")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','S1','1000')"><%=ht.get("CNT14")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('2','<%=ht.get("RENT_WAY")%>','','')"><%=ht.get("CNT15")%></td>
                </tr>		
		<%	}%>	
		
		<!--재리스 결과가 2개 아닐때-->
		<%	if(vt_size<2){
				for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><td width="80" rowspan="3" align="center">재리스</td><%}%>
                    <td width="80" align="center"><%if(cnt1[5]==0 && i==0){%>기본식<%}else{%>일반식<%}%></td>
			<%	for (int j = 0 ; j < size ; j++){
					t_cnt1[j] = t_cnt1[j]+ 0;
					t_cnt2[j] = t_cnt2[j]+ 0;
			%>	
                    <td align="right"><%=0%></td>
			<%	}%>
                </tr>						
		<%		}
			}%>			
			
                <tr> 
                    <td width="80" class=title>소계</td>
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = cnt1[j]+cnt2[j];
				t_cnt0[j] = t_cnt0[j]+cnt0[j];%>
                    <td class=title style='text-align:right'><%=cnt0[j]%></td>
			<%}%>
                </tr>		
                
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = 0;
				cnt1[j] = 0;
				cnt2[j] = 0;
			}%>
			
		<!--연장-->
		<%	vt = sb_db.getStatDeptList("3", gubun1, st_dt, end_dt);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				for (int j = 0 ; j < size ; j++){
					if(String.valueOf(ht.get("RENT_WAY")).equals("기본식")){
						cnt1[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt1[j] = t_cnt1[j]+ cnt1[j];
					}else if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){
						cnt2[j] = AddUtil.parseInt((String)ht.get("CNT"+(j)));
						t_cnt2[j] = t_cnt2[j]+ cnt2[j];
					}
				}
		%>
                <tr> 
                    <%if(i==0){%><td width="80" rowspan="3" align="center"><%=ht.get("CAR_GU")%></td><%}%>
                    <td width="80" align="center"><%=ht.get("RENT_WAY")%></td>					
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S1','0001')"><%=ht.get("CNT0")%></a></td>
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S1','0002')"><%=ht.get("CNT1")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S1','')"><%=ht.get("CNT2")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','B1','0007')"><%=ht.get("CNT3")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','D1','0008')"><%=ht.get("CNT4")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S2','0009')"><%=ht.get("CNT5")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','J1','0010')"><%=ht.get("CNT6")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','G1','0011')"><%=ht.get("CNT7")%></td>                    
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','I1','0012')"><%=ht.get("CNT8")%></td> 
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','K3','0013')"><%=ht.get("CNT9")%></td> 
		    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S3','0014')"><%=ht.get("CNT10")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S4','0015')"><%=ht.get("CNT11")%></td>
		    <!--<td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','U1','0016')"><%=ht.get("CNT12")%></td>-->
		    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S5','0017')"><%=ht.get("CNT12")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S6','0018')"><%=ht.get("CNT13")%></td>
		    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','S1','1000')"><%=ht.get("CNT14")%></td>
                    <td align="right"><a href="javascript:open_rent_dept('3','<%=ht.get("RENT_WAY")%>','','')"><%=ht.get("CNT15")%></td>

                    
					
                </tr>		
		<%	}%>	
		
		<!--연장 결과가 2개 아닐때-->
		<%	if(vt_size<2){
				for(int i = 0 ; i < 2-vt_size ; i++){%>
                <tr> 
                    <%if(i==0 && vt_size==0){%><td width="80" rowspan="3" align="center">연장</td><%}%>
                    <td width="80" align="center"><%if(cnt1[5]==0 && i==0){%>기본식<%}else{%>일반식<%}%></td>
			<%	for (int j = 0 ; j < size ; j++){
					t_cnt1[j] = t_cnt1[j]+ 0;
					t_cnt2[j] = t_cnt2[j]+ 0;
			%>	
                    <td align="right"><%=0%></td>
			<%	}%>
                </tr>						
		<%		}
			}%>			
			
                <tr> 
                    <td width="80" class=title>소계</td>
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = cnt1[j]+cnt2[j];
				t_cnt0[j] = t_cnt0[j]+cnt0[j];%>
                    <td class=title style='text-align:right'><%=cnt0[j]%></td>
			<%}%>
                </tr>	 
                
		<!--합계-->							
                <tr> 
                    <td colspan="2" class=title>합계</td>                    
			<%for (int j = 0 ; j < size ; j++){%>	
                    <td class=title style='text-align:right'><%=t_cnt0[j]%></td>
			<%}%>
                </tr>			                               	
			
			<%for (int j = 0 ; j < size ; j++){
				cnt0[j] = 0;
				cnt1[j] = 0;
				cnt2[j] = 0;
			}%>			
																					
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>					    
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
		<!--월렌트-->		
		<%	vt = sb_db.getStatDeptRmList("", gubun1, st_dt, end_dt);
			vt_size = vt.size();%>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>							
                <tr> 
                    <%if(i==0){%><td width="160" rowspan="<%=vt_size%>" align="center">월렌트</td><%}%>                    
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','S1','0001')"><%=ht.get("CNT0")%></a></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','S1','0002')"><%=ht.get("CNT1")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','S1','')"><%=ht.get("CNT2")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','B1','0007')"><%=ht.get("CNT3")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','D1','0008')"><%=ht.get("CNT4")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','S2','0009')"><%=ht.get("CNT5")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','J1','0010')"><%=ht.get("CNT6")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','G1','0011')"><%=ht.get("CNT7")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','I1','0012')"><%=ht.get("CNT8")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_ST")%>','K3','0013')"><%=ht.get("CNT9")%></td>
		    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_WAY")%>','S3','0014')"><%=ht.get("CNT10")%></td>
		    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_WAY")%>','S4','0015')"><%=ht.get("CNT11")%></td>
		    <!--<td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_WAY")%>','U1','0016')"><%=ht.get("CNT12")%></td>-->
		    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_WAY")%>','S5','0017')"><%=ht.get("CNT12")%></td>
		    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_WAY")%>','S6','0018')"><%=ht.get("CNT13")%></td>
		    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_WAY")%>','S1','1000')"><%=ht.get("CNT14")%></td>
                    <td width="80" align="right"><a href="javascript:open_rent_dept('4','<%=ht.get("RENT_WAY")%>','','')"><%=ht.get("CNT15")%></td>

                </tr>		
                <%	}%>
                
		<!--월렌트 결과가 없을때-->
		<%	if(vt_size==0){%>
                <tr> 
                    <td width="160" align="center">월렌트</td>
			<%	for (int j = 0 ; j < size ; j++){
					t_cnt1[j] = t_cnt1[j]+ 0;
					t_cnt2[j] = t_cnt2[j]+ 0;
			%>	
                    <td width="80" align="right"><%=0%></td>
			<%	}%>
                </tr>						
		<%	}%>	
			                
            </table>
        </td>
    </tr>
                
    <tr>
      <td></td>
    </tr>						
                    
    <tr>
      <td>※ 출고전해지/개시전해지/계약승계/차종변경은 제외, 중고차는 재리스에 포함</td>
    </tr>						
</table>
</form>
</body>
</html>