<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.Date"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<style type="text/css">
<!--
	td,body {font-size:12px; font-family:±º∏≤; text-decoration:none; color:black}
	th {font-size:12px; font-family:±º∏≤; font-weight : bold; text-decoration:none; color:white}
	a:link {font-size:12px; font-family:±º∏≤; text-decoration:none; color:black}
	a:visited {font-size:12px; font-family:±º∏≤; text-decoration:none; color:black}
	a:hover {  font-size: 12px; text-decoration: blink; color:red}
//-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body onLoad="self.focus()">
<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	Hashtable reserv = rs_db.getReserveSearchCase(c_id);
%>
<form name="form1" method="post" action="">
 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='mode' value=''>
 <input type='hidden' name='year' value=''>
 <input type='hidden' name='month' value=''>   
 <input type='hidden' name='date' value=''>    
  <table border=0 cellspacing=0 cellpadding=0 width=675>
    <tr> 
      <td colspan="2" height="30" bgcolor="#669900" align="center"><font color="#FFFFFF">√‡ 
        ±∏ ¿Â</font></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td align="center" colspan="2" height="24"> 
        <table bordercolor=#8f8f8f cellspacing=0 bordercolordark=white 
            cellpadding=5 width="100%" bordercolorlight=#8f8f8f border=1 align="center">
          <tbody> 
          <tr> 
            <td width="45" align="center"><font color="#999999">A-1</font></td>
            <td align="center" width="45"><font color="#999999">A-3</font></td>
            <td align="center" width="45"><font color="#999999">A-5</font></td>
            <td align="center" width="45"><font color="#999999">A-7</font></td>
            <td align="center" width="45"><font color="#999999">A-9</font></td>
            <td align="center" width="45"><font color="#999999">A-11</font></td>
            <td align="center" width="45"><font color="#999999">A-13</font></td>
            <td align="center" width="45"><font color="#999999">A-15</font></td>
            <td align="center" width="45"><font color="#999999">A-17</font></td>
            <td align="center" width="45" bgcolor="#E0CDEB"><b><font color="#000000">A-19</font></b></td>
            <td align="center" width="45"><font color="#999999">A-21</font></td>
            <td align="center" width="45"><font color="#999999">A-23</font></td>
            <td align="center" width="45"><font color="#999999">A-25</font></td>
            <td align="center" width="45"><font color="#999999">A-27</font></td>
            <td align="center" width="45"><font color="#999999">A-29</font></td>
          </tr>
          <tr> 
            <td align="center"><font color="#999999">A-2</font></td>
            <td align="center"><font color="#999999">A-4</font></td>
            <td align="center"><font color="#999999">A-6</font></td>
            <td align="center"><font color="#999999">A-8</font></td>
            <td align="center"><font color="#999999">A-10</font></td>
            <td align="center"><font color="#999999">A-12</font></td>
            <td align="center"><font color="#999999">A-14</font></td>
            <td align="center"><font color="#999999">A-16</font></td>
            <td align="center"><font color="#999999">A-18</font></td>
            <td align="center"><font color="#999999">A-20</font></td>
            <td align="center"><font color="#999999">A-22</font></td>
            <td align="center"><font color="#999999">A-24</font></td>
            <td align="center"><font color="#999999">A-26</font></td>
            <td align="center"><font color="#999999">A-28</font></td>
            <td align="center"> 
              <p><font color="#999999">A-30</font></p>
            </td>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td align="center" colspan="2" height="24"> 
        <table bordercolor=#8f8f8f cellspacing=0 bordercolordark=white 
            cellpadding=5 width="100%" bordercolorlight=#8f8f8f border=1 align="center">
          <tbody> 
          <tr> 
            <td width="45" align="center"><font color="#999999">B-1</font></td>
            <td align="center" width="45"><font color="#999999">B-3</font></td>
            <td align="center" width="45"><font color="#999999">B-5</font></td>
            <td align="center" width="45"><font color="#999999">B-7</font></td>
            <td align="center" width="45"><font color="#999999">B-9</font></td>
            <td align="center" width="45"><font color="#999999">B-11</font></td>
            <td align="center" width="45"><font color="#999999">B-13</font></td>
            <td align="center" width="45"><font color="#999999">B-15</font></td>
            <td align="center" width="45"><font color="#999999">B-17</font></td>
            <td align="center" width="45"><font color="#999999">B-19</font></td>
            <td align="center" width="45"><font color="#999999">B-21</font></td>
            <td align="center" width="45"><font color="#999999">B-23</font></td>
            <td align="center" width="45"><font color="#999999">B-25</font></td>
            <td align="center" width="45"><font color="#999999">B-27</font></td>
            <td align="center" width="45"><font color="#999999">B-29</font></td>
          </tr>
          <tr> 
            <td align="center"><font color="#999999">B-2</font></td>
            <td align="center"><font color="#999999">B-4</font></td>
            <td align="center"><font color="#999999">B-6</font></td>
            <td align="center"><font color="#999999">B-8</font></td>
            <td align="center"><font color="#999999">B-10</font></td>
            <td align="center"><font color="#999999">B-12</font></td>
            <td align="center"><font color="#999999">B-14</font></td>
            <td align="center"><font color="#999999">B-16</font></td>
            <td align="center"><font color="#999999">B-18</font></td>
            <td align="center"><font color="#999999">B-20</font></td>
            <td align="center"><font color="#999999">B-22</font></td>
            <td align="center"><font color="#999999">B-24</font></td>
            <td align="center"><font color="#999999">B-26</font></td>
            <td align="center"><font color="#999999">B-28</font></td>
            <td align="center"> 
              <p><font color="#999999">B-30</font></p>
            </td>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td align="center" colspan="2" height="24"> 
        <table bordercolor=#8f8f8f cellspacing=0 bordercolordark=white 
            cellpadding=5 width="100%" bordercolorlight=#8f8f8f border=1 align="center">
          <tbody> 
          <tr> 
            <td width="45" align="center"><font color="#999999">C-1</font></td>
            <td align="center" width="45"><font color="#999999">C-3</font></td>
            <td align="center" width="45"><font color="#999999">C-5</font></td>
            <td align="center" width="45"><font color="#999999">C-7</font></td>
            <td align="center" width="45"><font color="#999999">C-9</font></td>
            <td align="center" width="45"><font color="#999999">C-11</font></td>
            <td align="center" width="45"><font color="#999999">C-13</font></td>
            <td align="center" width="45"><font color="#999999">C-15</font></td>
            <td align="center" width="45"><font color="#999999">C-17</font></td>
            <td align="center" width="45"><font color="#999999">C-19</font></td>
            <td align="center" width="45"><font color="#999999">C-21</font></td>
            <td align="center" width="45"><font color="#999999">C-23</font></td>
            <td align="center" width="45"><font color="#999999">C-25</font></td>
            <td align="center" width="45"><font color="#999999">C-27</font></td>
            <td align="center" width="45"><font color="#999999">C-29</font></td>
          </tr>
          <tr> 
            <td align="center"><font color="#999999">C-2</font></td>
            <td align="center"><font color="#999999">C-4</font></td>
            <td align="center"><font color="#999999">C-6</font></td>
            <td align="center"><font color="#999999">C-8</font></td>
            <td align="center"><font color="#999999">C-10</font></td>
            <td align="center"><font color="#999999">C-12</font></td>
            <td align="center"><font color="#999999">C-14</font></td>
            <td align="center"><font color="#999999">C-16</font></td>
            <td align="center"><font color="#999999">C-18</font></td>
            <td align="center"><font color="#999999">C-20</font></td>
            <td align="center"><font color="#999999">C-22</font></td>
            <td align="center"><font color="#999999">C-24</font></td>
            <td align="center"><font color="#999999">C-26</font></td>
            <td align="center"><font color="#999999">C-28</font></td>
            <td align="center"> 
              <p><font color="#999999">C-30</font></p>
            </td>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td align="center" colspan="2" height="24"> 
        <table bordercolor=#8f8f8f cellspacing=0 bordercolordark=white 
            cellpadding=5 width="100%" bordercolorlight=#8f8f8f border=1 align="center">
          <tbody> 
          <tr> 
            <td width="45" align="center"><font color="#999999">D-1</font></td>
            <td align="center" width="45"><font color="#999999">D-3</font></td>
            <td align="center" width="45"><font color="#999999">D-5</font></td>
            <td align="center" width="45"><font color="#999999">D-7</font></td>
            <td align="center" width="45"><font color="#999999">D-9</font></td>
            <td align="center" width="45"><font color="#999999">D-11</font></td>
            <td align="center" width="45"><font color="#999999">D-13</font></td>
            <td align="center" width="45"><font color="#999999">D-15</font></td>
            <td align="center" width="45"><font color="#999999">D-17</font></td>
            <td align="center" width="45"><font color="#999999">D-19</font></td>
            <td align="center" width="45"><font color="#999999">D-21</font></td>
            <td align="center" width="45"><font color="#999999">D-23</font></td>
            <td align="center" width="45"><font color="#999999">D-25</font></td>
            <td align="center" width="45"><font color="#999999">D-27</font></td>
            <td align="center" width="45"><font color="#999999">D-29</font></td>
          </tr>
          <tr> 
            <td align="center"><font color="#999999">D-2</font></td>
            <td align="center"><font color="#999999">D-4</font></td>
            <td align="center"><font color="#999999">D-6</font></td>
            <td align="center"><font color="#999999">D-8</font></td>
            <td align="center"><font color="#999999">D-10</font></td>
            <td align="center"><font color="#999999">D-12</font></td>
            <td align="center"><font color="#999999">D-14</font></td>
            <td align="center"><font color="#999999">D-16</font></td>
            <td align="center"><font color="#999999">D-18</font></td>
            <td align="center"><font color="#999999">D-20</font></td>
            <td align="center"><font color="#999999">D-22</font></td>
            <td align="center"><font color="#999999">D-24</font></td>
            <td align="center"><font color="#999999">D-26</font></td>
            <td align="center"><font color="#999999">D-28</font></td>
            <td align="center"> 
              <p><font color="#999999">D-30</font></p>
            </td>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td align="center" colspan="2" height="24"> 
        <table bordercolor=#8f8f8f cellspacing=0 bordercolordark=white 
            cellpadding=5 width="100%" bordercolorlight=#8f8f8f border=1 align="center">
          <tbody> 
          <tr> 
            <td width="45" align="center"><font color="#999999">E-1</font></td>
            <td align="center" width="45"><font color="#999999">E-3</font></td>
            <td align="center" width="45"><font color="#999999">E-5</font></td>
            <td align="center" width="45"><font color="#999999">E-7</font></td>
            <td align="center" width="45"><font color="#999999">E-9</font></td>
            <td align="center" width="45"><font color="#999999">E-11</font></td>
            <td align="center" width="45"><font color="#999999">E-13</font></td>
            <td align="center" width="45"><font color="#999999">E-15</font></td>
            <td align="center" width="45"><font color="#999999">E-17</font></td>
            <td align="center" width="45"><font color="#999999">E-19</font></td>
            <td align="center" width="45"><font color="#999999">E-21</font></td>
            <td align="center" width="45"><font color="#999999">E-23</font></td>
            <td align="center" width="45"><font color="#999999">E-25</font></td>
            <td align="center" width="45"><font color="#999999">E-27</font></td>
            <td align="center" width="45"><font color="#999999">E-29</font></td>
          </tr>
          <tr> 
            <td align="center"><font color="#999999">E-2</font></td>
            <td align="center"><font color="#999999">E-4</font></td>
            <td align="center"><font color="#999999">E-6</font></td>
            <td align="center"><font color="#999999">E-8</font></td>
            <td align="center"><font color="#999999">E-10</font></td>
            <td align="center"><font color="#999999">E-12</font></td>
            <td align="center"><font color="#999999">E-14</font></td>
            <td align="center"><font color="#999999">E-16</font></td>
            <td align="center"><font color="#999999">E-18</font></td>
            <td align="center"><font color="#999999">E-20</font></td>
            <td align="center"><font color="#999999">E-22</font></td>
            <td align="center"><font color="#999999">E-24</font></td>
            <td align="center"><font color="#999999">E-26</font></td>
            <td align="center"><font color="#999999">E-28</font></td>
            <td align="center"> 
              <p><font color="#999999">E-30</font></p>
            </td>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="2" height="30" bgcolor="#999999" align="center"><font color="#FFFFFF">¥Ÿ 
        ∏Æ</font></td>
    </tr>
  </table>
</form>
</body>
</html>