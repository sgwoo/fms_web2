<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String maker = request.getParameter("maker")==null?"0001":request.getParameter("maker");
	String gubun2 	= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	
	Vector cars = ad_db.getStatMakerCarDt(maker, gubun2, gubun3, gubun4, st_dt, end_dt);
	int cars_size = cars.size();
	int row_cnt = 0, cnt=0;
	
	String s_st[]	 		= new String[13];//�Һз�����
	
	int s_year[]	 		= new int[32]; //2000�⵵���� 2015�����(17)->2020�����(22)
	int t_year[]	 		= new int[32];
	int l_year[]	 		= new int[32];
	
	int t_s_year = 0;
	int t_t_year = 0;
	int t_l_year = 0;
	
	
	s_st[0]  = "1";
	s_st[1]  = "2";
	s_st[2]  = "3";
	s_st[3]  = "4";
	s_st[4]  = "2L";
	s_st[5]  = "3L";
	s_st[6]  = "4L";
	s_st[7]  = "5";
	s_st[8]  = "6";
	s_st[9]  = "7";
	s_st[10] = "8";
	s_st[11] = "9";
	s_st[12] = "";	
	
	//int start_year 	= 2007;					//ǥ�ý��۳⵵
	int end_year 	= AddUtil.getDate2(1);			//����⵵
	int start_year 	= end_year-10;					//ǥ�ý��۳⵵
 	int td_size 	= end_year-start_year+1;		//ǥ�ó⵵����
 	int td_width 	= 66/td_size;				//ǥ�ó⵵ ������  (66=����+��������)
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title ���� */
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
            <% 			String s_st_nm = "";
            
				for(int j=0; j<13; j++){ //���������� 29�� ����->13��
					if(s_st[j].equals("1")) 	s_st_nm = "��¿�";		//1 "��¿륰"
					if(s_st[j].equals("2")) 	s_st_nm = "�����¿�";		//3
					if(s_st[j].equals("3")) 	s_st_nm = "�����¿�";		//4
					if(s_st[j].equals("4")) 	s_st_nm = "�����¿�";		//5 "�����¿�I"
					if(s_st[j].equals("2L")) 	s_st_nm = "�����¿�LPG";	//29
					if(s_st[j].equals("3L")) 	s_st_nm = "�����¿�LPG";	//10
					if(s_st[j].equals("4L")) 	s_st_nm = "�����¿�LPG";	//11
					if(s_st[j].equals("5")) 	s_st_nm = "5�ν�¤";		//12 "5�ν�¤<br>2000cc����"
					if(s_st[j].equals("6")) 	s_st_nm = "7~8�ν�";		//14 "7~8�ν�<br>2000cc����"
					if(s_st[j].equals("7"))		s_st_nm = "9�ν�";		//16 "9�ν�<br>2000cc����"
					if(s_st[j].equals("8")) 	s_st_nm = "����";		//18 "11~12�ν�"
					if(s_st[j].equals("9")) 	s_st_nm = "ȭ��";		//20 "��ȭ��"
					if(s_st[j].equals("")) 		s_st_nm = "��Ÿ";		//30
					
	        			row_cnt = 0; cnt=0;
					for(int i=0; i<22; i++){
						t_year[i] = 0;
					}
        				for(int i=0; i<cars.size(); i++){
	        				Hashtable ht = (Hashtable)cars.elementAt(i);
    	    					if(String.valueOf(ht.get("S_ST")).equals(s_st[j])){
        						row_cnt += 1;
        					}
        				}
	        			for(int i=0; i<cars.size(); i++){
    	    					Hashtable ht = (Hashtable)cars.elementAt(i);
        					if(String.valueOf(ht.get("S_ST")).equals(s_st[j])){
        						cnt += 1;
							
							//�������к��Ұ�
							for(int h = start_year ; h <= end_year ; h++){
	    	    						t_year[h-start_year] += AddUtil.parseInt((String)ht.get("Y"+h));
							}
							
							//��ü�հ�
							for(int h = start_year ; h <= end_year ; h++){
	    	    						s_year[h-start_year] += AddUtil.parseInt((String)ht.get("Y"+h));
							}
							
							//LPG�����϶� �հ�							
							if(String.valueOf(ht.get("S_ST")).equals("2L") || String.valueOf(ht.get("S_ST")).equals("3L") || String.valueOf(ht.get("S_ST")).equals("4L")){
								for(int h = start_year ; h <= end_year ; h++){
	    	    							l_year[h-start_year] += AddUtil.parseInt((String)ht.get("Y"+h));
								}
							}
        		 %>
                <tr> 
                    <% if(cnt==1){ %>
                    <td width="9%" class="title" rowspan="<%= row_cnt %>"><%=s_st_nm%></td>
                    <% } %>
                    <td width="14%" class="title"><%= ht.get("CAR_NM") %></td>
                    <td width="<%=100-23-(td_width*td_size)%>%" align="right"><%= ht.get("TOTAL") %></td>
					<%for(int k = end_year ; k >= start_year ; k--){//����⵵%>
                    <td width="<%=td_width%>%" align="right"><%= ht.get("Y"+k) %></td>					
					<%}%>
                </tr>
                <%		}
        			} %>
					
				<%	int t_year_h = 0;
					for(int k = end_year ; k >= start_year ; k--){
						t_year_h = t_year_h + t_year[k-start_year];
					}
					if(t_year_h > 0){%>	
                <tr> 
                    <td colspan='2' class="title">�Ұ�</td>
                    <td align="right"><%= t_year_h%></td>
					<%for(int k = end_year ; k >= start_year ; k--){//����⵵%>
                    <td align="right"><%= t_year[k-start_year] %></td>		  
					<%}%>
                </tr>
				<%	}%>									
				<%}%>
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
			t_l_year = t_l_year + l_year[k-start_year];
		}%>
	
	//�հ�
	<%for(int k = end_year ; k >= start_year ; k--){//����⵵%>
	pfm.s<%=k%>[0].value = '<%= s_year[k-start_year] %>';	
	<%}%>
	pfm.s_all[0].value = '<%= t_s_year %>';	

	//LPG�������
	<%for(int k = end_year ; k >= start_year ; k--){//����⵵%>
	pfm.s<%=k%>[1].value = '<%= l_year[k-start_year] %>';	
	<%}%>
	pfm.s_all[1].value = '<%= t_l_year %>';	
	
	//LPG����%
	<%for(int k = end_year ; k >= start_year ; k--){//����⵵%>	
	pfm.s<%=k%>[2].value = parseFloatCipher3(<%= l_year[k-start_year] %>/<%= s_year[k-start_year] %>*100,2);	
	<%}%>
	pfm.s_all[2].value = parseFloatCipher3(<%= t_l_year %>/<%= t_s_year %>*100,2);	
	
	//��LPG�������
	<%for(int k = end_year ; k >= start_year ; k--){//����⵵%>		
	pfm.s<%=k%>[3].value = '<%= s_year[k-start_year]-l_year[k-start_year] %>';	
	<%}%>
	pfm.s_all[3].value = '<%= t_s_year-t_l_year %>';	
	
	//��LPG����%
	<%for(int k = end_year ; k >= start_year ; k--){//����⵵%>			
	pfm.s<%=k%>[4].value = parseFloatCipher3(<%= s_year[k-start_year]-l_year[k-start_year] %>/<%= s_year[k-start_year] %>*100,2);	
	<%}%>
	pfm.s_all[4].value = parseFloatCipher3(<%= t_s_year-t_l_year %>/<%= t_s_year %>*100,2);	

</script>
