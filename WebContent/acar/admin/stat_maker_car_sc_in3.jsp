<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String maker = request.getParameter("maker")==null?"0001":request.getParameter("maker");
	String gubun2 	= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	
	Vector cars = ad_db.getStatMakerCarDt3(maker, gubun2, gubun3, gubun4, st_dt, end_dt);
	int cars_size = cars.size();
	int row_cnt = 0, cnt=0;
	
	
	
	int st_idx = 0;
	
	for(int i=0; i<cars.size(); i++){
		Hashtable ht = (Hashtable)cars.elementAt(i);
    	    	if(!String.valueOf(ht.get("CAR_COMP_ID")).equals("") && String.valueOf(ht.get("CAR_NM")).equals("")){
        		st_idx += 1;
        	}
        }	
	
	String s_st[]	 		= new String[st_idx];//제조사 갯수
	String s_st_cnt[]	 	= new String[st_idx];//제조사별 갯수
	
	int s_year[]	 		= new int[32]; //2000년도부터 2015년까지(17)->2020년까지(22)
	int t_year[]	 		= new int[32];
	int l_year[]	 		= new int[32];
	
	int t_s_year = 0;
	int t_t_year = 0;
	int t_l_year = 0;
	
	int st_idx2 = 0;
	
	for(int i=0; i<cars.size(); i++){
		Hashtable ht = (Hashtable)cars.elementAt(i);
    	    	if(!String.valueOf(ht.get("CAR_COMP_ID")).equals("") && String.valueOf(ht.get("CAR_NM")).equals("")){    	    		
        		s_st[st_idx2]  = String.valueOf(ht.get("CAR_COMP_ID"));
        		st_idx2 +=1;
        	}
        }	
        
	//int start_year 	= 2007;				//표시시작년도	
	int end_year 	= AddUtil.getDate2(1);		//현재년도
	int start_year 	= end_year-10;					//표시시작년도
 	int td_size 	= end_year-start_year+1;	//표시년도갯수
 	int td_width 	= 66/td_size;			//표시년도 사이즈 
 	
	//int start_year 	= 2007;					//표시시작년도
	//int end_year 	= AddUtil.getDate2(1);			//현재년도
 	//int td_size 	= end_year-start_year+1;		//표시년도갯수
 	//int td_width 	= 66/td_size;				//표시년도 사이즈  (66=구분+차종넓이)
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
	
	function OpenList(client_id, firm_nm){
		var SUBWIN = "stat_mng_client_car_list.jsp";
		window.open(SUBWIN+"?client_id="+client_id+"&firm_nm="+firm_nm, "OpenList", "left=50, top=50, width=950, height=500, scrollbars=yes");
	}

	function OpenCarList(s_st){
		var SUBWIN = "stat_maker_car_list.jsp";
		window.open(SUBWIN+"?s_st="+s_st+"&maker=<%=maker%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>", "OpenCARList", "left=50, top=50, width=550, height=800, scrollbars=yes");
	}
	
//-->
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
            <% 			for(int j=0; j<st_idx; j++){
					
					
	        			row_cnt = 0; cnt=0;
					for(int i=0; i<22; i++){
						t_year[i] = 0;
					}
        				for(int i=0; i<cars.size(); i++){
	        				Hashtable ht = (Hashtable)cars.elementAt(i);
    	    					if(String.valueOf(ht.get("CAR_COMP_ID")).equals(s_st[j])){
        						row_cnt += 1;
        					}
        				}
	        			for(int i=0; i<cars.size(); i++){
    	    					Hashtable ht = (Hashtable)cars.elementAt(i);
        					if(String.valueOf(ht.get("CAR_COMP_ID")).equals(s_st[j])){
        						cnt += 1;
													
							if(String.valueOf(ht.get("CAR_NM")).equals("")){								
								//전체합계
								for(int h = start_year ; h <= end_year ; h++){
	    	    							s_year[h-start_year] += AddUtil.parseInt((String)ht.get("Y"+h));
								}
							}
							
        		 %>
                <tr> 
                    <% if(cnt==1){ %>
                    <td width="9%" class="title" rowspan="<%= row_cnt %>"><%=ht.get("CAR_COMP_ID")%></td>
                    <% } %>
                    <td width="14%" class="title"><%= ht.get("CAR_NM") %><%if(String.valueOf(ht.get("CAR_NM")).equals("")){%>소계<%}%></td>
                    <td width="<%=100-23-(td_width*td_size)%>%" align="right"><%= ht.get("TOTAL") %></td>
		    <%for(int k = end_year ; k >= start_year ; k--){//현재년도%>
                    <td width="<%=td_width%>%" align="right"><%= ht.get("Y"+k) %></td>					
		    <%}%>
                </tr>
                <%				}
        				} %>					
		<%		}%>													
            </table>
        </td>
    </tr>
</table>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
	pfm = parent.form1;
	
	<% 	for(int k = end_year ; k >= start_year ; k--){
			t_s_year = t_s_year + s_year[k-start_year];			
		}%>
	
	//합계
	<%for(int k = end_year ; k >= start_year ; k--){//현재년도%>
	pfm.s<%=k%>.value = '<%= s_year[k-start_year] %>';	
	<%}%>
	pfm.s_all.value = '<%= t_s_year %>';	


</script>
